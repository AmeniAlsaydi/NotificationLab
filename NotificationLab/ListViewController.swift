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
    
    private var refreshControl: UIRefreshControl!

    // data for table view
    private var timerNotifications = [UNNotificationRequest]() {
      didSet {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
    
    private let pendingNotification = PendingNotification()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        configureRefreshControl()
        checkForNotificationAuthorization()
        loadNotifications()
        center.delegate = self // setting this vc as the unnotificationcenter delegate
    }
    
    private func configureRefreshControl() {
           refreshControl = UIRefreshControl()
           tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged) // at the event of value changing
           
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let createVC =  navController.viewControllers.first as? CreateViewController else {
            fatalError("couldnt get createVc")
        }
        
        createVC.delegate = self
    }
    
    @objc private func loadNotifications() {
      pendingNotification.getPendingNotifications { (requests) in
        self.timerNotifications = requests
         
        DispatchQueue.main.async {
          self.refreshControl.endRefreshing() // stop the refresh control from animating and remove from the UI
        }
      }
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
        return timerNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        let timerNotification = timerNotifications[indexPath.row]
        cell.textLabel?.text = timerNotification.content.title
        cell.detailTextLabel?.text = timerNotification.content.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            // delete pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
    private func removeNotification(atIndexPath indexpath: IndexPath) {
         let timeNotification = timerNotifications[indexpath.row]
        let identifier = timeNotification.identifier
        
        // remove from notification from UNNotification center
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        // remove from array
        timerNotifications.remove(at: indexpath.row)
        // remove from table view
        tableView.deleteRows(at: [indexpath], with: .automatic)
        
    }
}

extension ListViewController: CreateVCDelegate {
    func didCreateTimer(_ createVC: CreateViewController) {
        loadNotifications()
    }
}

extension ListViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler(.alert)
    }
}

extension Double {
func convertTime() -> String {
       let date = Date(timeIntervalSince1970: self)
       let dateFormatter = DateFormatter()
       dateFormatter.timeStyle = DateFormatter.Style.medium
       dateFormatter.dateFormat = "h:mm a"
       dateFormatter.timeZone = .current
       let localDate = dateFormatter.string(from: date)
       return localDate
   }
}
