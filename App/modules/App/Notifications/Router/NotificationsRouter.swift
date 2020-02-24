//
//  NotificationsNotificationsRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class NotificationsRouter: NotificationsRouterInput, TabbedRouter {

    var navController: UINavigationController?
    var repository: DataRepository!
    var sessionManager: SessionManager!
    
    init(repository: DataRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }

    func start() {

        let controller = NotificationsViewController()

        let presenter = NotificationsPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = NotificationsInteractor()
        interactor.output = presenter

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
}
