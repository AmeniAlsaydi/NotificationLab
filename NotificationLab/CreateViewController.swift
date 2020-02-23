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

    override func viewDidLayoutSubviews() {
        addButton.layer.cornerRadius = 10
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func timerChanged(_ sender: UIDatePicker) {
        
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        delegate?.didCreateTimer(self)
    }
}

