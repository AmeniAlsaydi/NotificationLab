//
//  PendingTimerNotifications.swift
//  NotificationLab
//
//  Created by Amy Alsaydi on 2/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    // retrieves all pending notifications in notification center
    // how do we differentiate between the different notification requests made by the same app
    // is that even smth we would want to do?
  public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
      print("there are \(requests.count) pending requests.")
      completion(requests)
    }
  }
}
