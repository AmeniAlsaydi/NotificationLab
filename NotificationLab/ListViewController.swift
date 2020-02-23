//
//  ListViewController.swift
//  NotificationLab
//
//  Created by Amy Alsaydi on 2/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import UserNotifications

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        checkForNotificationAuthorization()

    }
    
    private func checkForNotificationAuthorization() {
      center.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
          print("app is authorized for notifications")
        } else {
          self.requestNotificationPermissions()
        }
      }
    }
    
    private func requestNotificationPermissions() {
      center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        if let error = error {
          print("error requesting authorization: \(error)")
          return
        }
        if granted {
          print("access was granted")
        } else {
          print("access denied")
        }
      }
    }

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        return cell
    }
}
