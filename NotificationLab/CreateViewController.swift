//
//  ViewController.swift
//  NotificationLab
//
//  Created by Amy Alsaydi on 2/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol CreateVCDelegate: AnyObject {
    func didCreateTimer(_ createVC: CreateViewController)
}

class CreateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: CreateVCDelegate?
    
    
    private var timeInterval: TimeInterval! //dates and time are managed in time intervals (in seconds)
    
    override func viewDidLayoutSubviews() {
        addButton.layer.cornerRadius = addButton.bounds.width/2
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
    }
    
    private func createLocalNotification() {
        // step 1: create the content
        let content = UNMutableNotificationContent()
        content.title = textField.text ?? "No title"
        content.subtitle = "Timer is complete"
        content.sound = .default
        
        let identifier = UUID().uuidString // create indentifier - a unique String
        
        // attachment
        if let imageURL = Bundle.main.url(forResource: "clock", withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("error with attachment: \(error)")
            }
        } else {
            print("image resource could not be found")
        }
        
        // create trigger
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false) // repeat if its a reoccuring timer
        
        // create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotificationCenter
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                 print("successfully added request")
            }
        }
    }
    
    @IBAction func timerChanged(_ sender: UIDatePicker) {
        
        addButton.isEnabled = true
        
        timeInterval = sender.countDownDuration // Use this property to get and set the currently selected value when the date picker’s mode property is set to "countdown timer"
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        createLocalNotification()
        delegate?.didCreateTimer(self)
        dismiss(animated: true)
    }
}

