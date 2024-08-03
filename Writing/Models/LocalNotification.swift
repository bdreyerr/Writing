//
//  LocalNotification.swift
//  Writing
//
//  Created by Ben Dreyer on 7/28/24.
//

import Foundation

struct LocalNotification {
    internal init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.identifier = identifier
        self.title = title
        self.scheduleType = .time
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.identifier = identifier
        self.title = title
        self.scheduleType = .calendar
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum ScheduleType {
        case time, calendar
    }
    
    var identifier: String
    var title: String
    var scheduleType: ScheduleType
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
}
