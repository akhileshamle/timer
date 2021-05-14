//
//  NotificationProcessor.swift
//  Reminder
//
//  Created by Akhilesh Amle on 09/05/21.
//

import UIKit
import UserNotifications

class NotificationProcessor: NSObject {
    
    static let shared : NotificationProcessor = NotificationProcessor ()
    var error : Error?
    
    func permission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                // handle error
                self.error = error
            } else {
                self.error = nil
            }
        }
    }

    func scheduleNotification(min: Int, date: Date,_ completion: @escaping ((String?) -> ())) {
        UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "brow"
        content.subtitle = "\(min) min(s) passed"
        content.sound = UNNotificationSound.default
        let dateComponents = Calendar.current.dateComponents([.calendar,.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuid = UUID().uuidString
        let notificationRequest = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func removeAllDelivered() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func removeAllPending() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
