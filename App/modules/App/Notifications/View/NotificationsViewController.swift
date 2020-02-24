//
//  NotificationsNotificationsViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, NotificationsViewInput {

    var output: NotificationsViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Notifikationer".localize()
        
        output.viewIsReady()
    }


    // MARK: NotificationsViewInput
    func setupInitialState() {
    }
}
