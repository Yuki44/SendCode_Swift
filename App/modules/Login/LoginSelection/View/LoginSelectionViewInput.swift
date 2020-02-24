//
//  LoginSelectionLoginSelectionViewInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

protocol LoginSelectionViewInput: class where Self: UIViewController {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayError(_ error: Error)
    func loginCancelled()
}
