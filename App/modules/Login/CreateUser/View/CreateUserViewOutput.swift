//
//  CreateUserCreateUserViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import Foundation

@objc protocol CreateUserViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func createUserPressed(name: String, email: String, password: String)
    
    @objc func close()
}
