//
//  SettingsSettingsRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class SettingsRouter: SettingsRouterInput, TabbedRouter {
 
    var editProfileDelegate: EditProfileFormDelegate?
    var navController: UINavigationController?
    var repository: DataRepository!
    var sessionManager: SessionManager!
    
    init(repository: DataRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func start() {

        let controller = SettingsViewController()
        self.editProfileDelegate = controller
        
        let presenter = SettingsPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = SettingsInteractor()
        interactor.output = presenter
        interactor.repository = self.repository
        interactor.sessionManager = self.sessionManager

        presenter.interactor = interactor
        controller.output = presenter

        self.navController = UINavigationController(rootViewController: controller)
        self.navController?.navigationBar.prefersLargeTitles = true
    }
    
    func cleanUp() {
        self.navController = nil
    }

    func controllerForTab() -> UIViewController {
        assert(self.navController != nil, "You must call .start() before calling controllerForTab()")
        return self.navController!
    }
    
    func logout() {
        self.sessionManager.logout()
    }
    
    func routeTo(type: SettingsMenuItemType) {
        
        switch type {
        case .EditProfile:
            let router = EditProfileRouter(sessionManager: self.sessionManager,
                                           repository: self.repository,
                                           finishDelegate: self.editProfileDelegate!)
            router.start(from: self.navController!)
        case .CreditCards:
            let router = CreditCardsRouter(repository: self.repository)
            router.start(from: self.navController!)
        case .FastTrack:
            let router = FastTrackRouter(repository: self.repository)
            router.start(from: self.navController!)
        case .Terms:
            let router = TermsAndConditionsRouter()
            router.start(from: self.navController!)
        case .Help:
            let router = HelpRouter()
            router.start(from: self.navController!)
        }
    }
}
