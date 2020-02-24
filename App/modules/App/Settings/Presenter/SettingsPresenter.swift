//
//  SettingsSettingsPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class SettingsPresenter: SettingsModuleInput, SettingsViewOutput, SettingsInteractorOutput {

    weak var view: SettingsViewInput!
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!

    func viewIsReady() {
        self.view.setupInitialState()
        self.interactor.fetchUser()
    }
    
    func userReady(_ user: UserModel) {
        self.view.displayUser(user)
    }
    
    func fetchUserFailed() {
        self.router.logout()
    }
    
    func logoutPressed() {
        self.router.logout()
    }
    
    func menuItemPressed(item: SettingsMenuItem) {
        self.router.routeTo(type: item.type)
    }
    
    func uploadNewAvatar(image: UIImage) {
        self.interactor.uploadAvatar(image: image)
    }
    
    func uploadAvatarFinished(user: UserModel) {
        self.view.displayUser(user)
    }
    
    func uploadAvatarFailed(error: Error) {
        self.view.displayError(error)
    }
}
