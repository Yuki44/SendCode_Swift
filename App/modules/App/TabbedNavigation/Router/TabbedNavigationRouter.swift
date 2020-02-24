//
//  TabbedNavigationTabbedNavigationRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class TabbedNavigationRouter: TabbedNavigationRouterInput {

    var repository: DataRepository!
    var sessionManager: SessionManager!
    var pushCordinator: PushCordinator!
    
    init(repository: DataRepository, sessionManager: SessionManager, pushCordinator: PushCordinator) {
        self.repository = repository
        self.sessionManager = sessionManager
        self.pushCordinator = pushCordinator
    }
    
    func start(in window: UIWindow) {
        
        let controller = TabbedNavigationViewController()

        let presenter = TabbedNavigationPresenter()
        presenter.view = controller
        presenter.router = self
        presenter.sessionManager = self.sessionManager
        presenter.repository = self.repository
        presenter.pushCordinator = self.pushCordinator

        let interactor = TabbedNavigationInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        controller.output = presenter

        window.rootViewController = controller
    }
    
    func logout() {
        self.sessionManager.logout()
    }
}
