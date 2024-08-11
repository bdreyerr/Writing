//
//  ProfileNotificationsView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/28/24.
//

import SwiftUI

struct ProfileNotificationsView: View {
    @EnvironmentObject var localNotificationController: LocalNotificationController
    
    var body: some View {
        if localNotificationController.isGranted {
            VStack {
                Toggle(isOn: $localNotificationController.areNotificationsEnabled) {
                    Text("Enable Notifications")
                        .font(.system(size: 15, design: .serif))
                        .bold()
                }
                .onChange(of: localNotificationController.areNotificationsEnabled) {
                    if localNotificationController.areNotificationsEnabled {
                        // enable
//                        print("enable notifs")
                        localNotificationController.enableNotifications()
                    } else {
                        // disable
//                        print("disable notifs")
                        localNotificationController.disableNotifications()
                    }
                }
                .padding(.bottom, 20)
                
                if localNotificationController.areNotificationsEnabled {
                    
                    HStack {
                        Text("Cadence")
                            .font(.system(size: 15, design: .serif))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Picker(localNotificationController.selectedCadence.rawValue, selection: $localNotificationController.selectedCadence) {
                            Text("Daily").tag(Cadence.daily)
                        }
                        .pickerStyle(.automatic)
                    }
                    .padding(.bottom, 20)
                    
                    
                    if localNotificationController.selectedCadence == .weekly {
                        HStack {
                            Text("Day Of Week")
                                .font(.system(size: 15, design: .serif))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Picker(localNotificationController.dayOfWeek.rawValue, selection: $localNotificationController.dayOfWeek) {
                                Text("Monday").tag(DayOfWeek.monday)
                                Text("Tuesday").tag(DayOfWeek.tuesday)
                                Text("Wednesday").tag(DayOfWeek.wednesday)
                                Text("Thursday").tag(DayOfWeek.thursday)
                                Text("Friday").tag(DayOfWeek.friday)
                                Text("Saturday").tag(DayOfWeek.saturday)
                                Text("Sunday").tag(DayOfWeek.sunday)
                            }
                            .pickerStyle(.menu)
                        }
                        .padding(.bottom, 20)
                    }
                    
                    
                    DatePicker(
                        selection: $localNotificationController.timeOfDay,
                        displayedComponents: [.hourAndMinute]
                    ) {
                        Text("Time of Day")
                            .font(.system(size: 15, design: .serif))
                            .bold()
                    }
                    .onChange(of: localNotificationController.timeOfDay) {
                        localNotificationController.updateNotificationSettings()
                    }
                    
                }
                
                
                Spacer()
            }
            .padding(.horizontal, 20)
        } else {
            VStack {
                Button("Eable Notifications - Open Settings") {
                    localNotificationController.openSettings()
                }
            }
        }
        
        
        
        // un comment to view pending notifiction requests in the view
//            if localNotificationController.isGranted {
//                Button("Interval noticiation") {
//                    Task {
//                        let localNotification = LocalNotification(identifier: UUID().uuidString,
//                                                                  title: "Some Title",
//                                                                  body: "some body",
//                                                                  timeInterval: 20,
//                                                                  repeats: false)
//                        await localNotificationController.schedule(localNotification: localNotification)
//                    }
//                }
//
//                List{
//                    ForEach(localNotificationController.pendingRequests, id: \.identifier) { request in
//                        VStack(alignment: .leading) {
//                            Text(request.content.title)
//                            HStack {
//                                Text(request.identifier)
//                                    .font(.caption)
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                        .swipeActions {
//                            Button("Delete", role: .destructive) {
//                                localNotificationController.removeRequest(withIdentifier: request.identifier)
//                            }
//                        }
//                    }
//                }
//            } else {
//                Button("enable notifications") {
//                    localNotificationController.openSettings()
//                }
//            }
    }
}

#Preview {
    ProfileNotificationsView()
        .environmentObject(LocalNotificationController())
}
