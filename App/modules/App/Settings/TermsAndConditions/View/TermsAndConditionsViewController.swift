//
//  TermsAndConditionsTermsAndConditionsViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController, TermsAndConditionsViewInput {

    var output: TermsAndConditionsViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Betingelser".localize()
        self.view.backgroundColor = Theme.backgroundColor
        
        output.viewIsReady()
    }


    // MARK: TermsAndConditionsViewInput
    func setupInitialState() {
    }
}
