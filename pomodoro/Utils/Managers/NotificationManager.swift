//
//  NotificationManager.swift
//  pomodoro
//
//  Created by vlsuv on 09.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NotificationManagerType {
    func sendNotification(with date: Date)
    func removeAllNotifications()
}

class NotificationManager: NotificationManagerType {
    
    // MARK: - Properties
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    init() {
        requestNotificationAuthorization()
    }
    
    // MARK: - Input Handlers
    func sendNotification(with date: Date) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "step is ended"
        notificationContent.sound = .default
        
        let components = Calendar(identifier: .gregorian).dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoro",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func removeAllNotifications() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}

// MARK: - Notification Helpers
extension NotificationManager {
    private func requestNotificationAuthorization() {
        let authOption = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOption) { succes, error in
            if let error = error {
                print(error)
            }
        }
        
    }
}
