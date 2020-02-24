//
//  HelpHelpViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, HelpViewInput {

    var output: HelpViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hjælp".localize()
        self.view.backgroundColor = Theme.backgroundColor
        
        output.viewIsReady()
    }


    // MARK: HelpViewInput
    func setupInitialState() {
    }
}
