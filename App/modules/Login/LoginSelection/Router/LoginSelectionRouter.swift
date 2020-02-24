//
//  LoginSelectionLoginSelectionRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

class LoginSelectionRouter: LoginSelectionRouterInput {
    
    var sessionManager: SessionManager
    var analyticsRepository: AnalyticsRepository
    
    init(sessionManager: SessionManager, analyticsRepository: AnalyticsRepository) {
        self.sessionManager = sessionManager
        self.analyticsRepository = analyticsRepository
    }
    
    func start(in window: UIWindow) {
        let viewController = LoginSelectionViewController()
        
        let presenter = LoginSelectionPresenter()
        presenter.view = viewController
        presenter.router = self
        presenter.analytics = analyticsRepository
        
        let interactor = LoginSelectionInteractor()
        interactor.output = presenter
        interactor.sessionManager = self.sessionManager
        
        presenter.interactor = interactor
        viewController.output = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
    }
    
    deinit {
        log.info("Deinit loginrouter")
    }
    
    func navigateToEmailSignIn(from viewController: UIViewController) {
        let router = SigninWithEmailRouter(sessionManager: self.sessionManager,
                                           analyticsRepository: self.analyticsRepository)
        router.start(from: viewController)
    }
    
    func navigateToCreateUser(from viewController: UIViewController) {
        let router = CreateUserRouter(sessionManager: self.sessionManager,
                                      analyticsRepository: self.analyticsRepository)
        router.start(from: viewController)
    }
}
