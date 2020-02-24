//
//  EditProfileEditProfilePresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

class EditProfilePresenter: EditProfileModuleInput, EditProfileViewOutput, EditProfileInteractorOutput {

    weak var view: EditProfileViewInput!
    var interactor: EditProfileInteractorInput!
    var router: EditProfileRouterInput!

    func viewIsReady() {
        self.interactor.fetchUser()
        self.view.setupInitialState()
    }
    
    func userReady(_ user: UserModel) {
        self.view.displayUser(user)
    }
    
    func fetchUserFailed() {
        
    }
    
    func updateUser(name: String, newPassword: String?) {
        self.interactor.updateUser(name: name, newPassword: newPassword)
    }
    
    func userUpdated(_ user: UserModel) {
        self.router.editProfileRouterFinished(user: user)
    }
    
    func failedToUpdateUser(error: Error) {
        self.view.displayError(error)
    }
    
}
