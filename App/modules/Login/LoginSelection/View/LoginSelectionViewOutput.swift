//
//  LoginSelectionLoginSelectionViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import Foundation
import UIKit

@objc protocol LoginSelectionViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    @objc func signInWithEmailPressed()
    @objc func createUserPressed()
    
    func signInWithFacebookPressed(from viewController: UIViewController)
    func signInWithApplePressed(from viewController: UIViewController)
}
