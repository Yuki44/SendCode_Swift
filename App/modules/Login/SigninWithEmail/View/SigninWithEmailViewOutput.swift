//
//  SigninWithEmailSigninWithEmailViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import Foundation

@objc protocol SigninWithEmailViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    @objc func close()
    func viewIsReady()
    func signInWith(email: String, password: String)
}
