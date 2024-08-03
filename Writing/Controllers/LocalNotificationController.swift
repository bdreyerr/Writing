//
//  LocalNotificationController.swift
//  Writing
//
//  Created by Ben Dreyer on 7/28/24.
//

import Foundation
import NotificationCenter
import SwiftUI

@MainActor
class LocalNotificationController : NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @AppStorage("notificationTimeOfDay") private var notificationTimeOfDay = ""
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Are notifications granted by the user on device for the app
    @Published var isGranted = false
    
    // Are notifications enabled for the app.
    @Published var areNotificationsEnabled: Bool = true
    
    @Published var selectedCadence: Cadence = .daily
    // Time of day notification fires
    @Published var timeOfDay = Date()
    // If notification fires once a week, which day it will fire
    @Published var dayOfWeek: DayOfWeek = .monday
    
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter
        }()
    
    // messages to put in the notifications
    var notificationMessages = ["Time to write! Open to see your latest prompt", "Today's prompt is ready for you!", "Have you written yet today?", "New prompt alert, get in here and start your flow", "It's time! Get those writing juices flowing"]
    
    override init() {
        super.init()
        notificationCenter.delegate = self
        
        self.timeOfDay = dateFormatter.date(from: notificationTimeOfDay) ?? Date()
        enableNotifications()
    }
    
    func enableNotifications() {
        Task {
            await getPendingRequests()
            
            if pendingRequests.isEmpty {
                // If this is the first time the app is loading the controller, and no notification has been scheduled yet. Then we should schedule one based on the default settings (Daily, 12 noon)
                print("no pending notification requests, we are going to schedule one based on the selected settings")
                
                // build the date component based on the settings
                var dateComponents = DateComponents()
                
                
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: self.timeOfDay)
                let minute = calendar.component(.minute, from: self.timeOfDay)
                
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                // schedule the notification
                let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                          title: "The Daily Short",
                                                          body: notificationMessages.randomElement() ?? "",
                                                          dateComponents: dateComponents,
                                                          repeats: true)
                await self.schedule(localNotification: localNotification)
            } else {
                print("a notification is already scheduled")
            }
        }
    }
    
    // the function which updates the notification to be sent next
    // called in the view when any of the following variables change:
    // - selectedCadence, timeOfDay, dayOfWeek
    func updateNotificationSettings() {
        print("notif settings got updated")
        disableNotifications()
        
        // update the AppStorage String Date
        let dateString = dateFormatter.string(from: timeOfDay)
        print("new timeOfDay: ", dateString)
        notificationTimeOfDay = dateString
        self.timeOfDay = dateFormatter.date(from: notificationTimeOfDay) ?? Date()
        
        
        // re-enable notification with new settings
        enableNotifications()
    }
    
    func disableNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        Task {
           await getPendingRequests()
        }
    }
    
    // Delegate function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        
        await getCurrentSetting()
    }
    
    func getCurrentSetting() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default
        
        if localNotification.scheduleType == .time {
            guard let timeInterval = localNotification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        await getPendingRequests()
    }
    
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
            print("Pending: \(pendingRequests.count)")
        }
    }
}


enum Cadence: String, CaseIterable, Identifiable {
    case daily, weekly
    var id: Self { self }
}

enum DayOfWeek: String, CaseIterable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    var id: Self { self }
}
