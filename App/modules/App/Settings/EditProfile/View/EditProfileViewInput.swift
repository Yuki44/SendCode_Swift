//
//  EditProfileEditProfileViewInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol EditProfileViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayUser(_ user: UserModel)
    func displayError(_ error: Error)
}
