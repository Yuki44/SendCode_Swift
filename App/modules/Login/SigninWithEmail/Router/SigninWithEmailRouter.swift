//
//  SigninWithEmailSigninWithEmailRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class SigninWithEmailRouter: SigninWithEmailRouterInput {

    var sessionManager: SessionManager
    var analyticsRepository: AnalyticsRepository
    weak var parent: UIViewController?

    init(sessionManager: SessionManager, analyticsRepository: AnalyticsRepository) {
        self.sessionManager = sessionManager
        self.analyticsRepository = analyticsRepository
    }
        
    func start(from viewController: UIViewController) {
        self.parent = viewController
        
        let signInWithEmailViewController = SigninWithEmailViewController()
        
        let presenter = SigninWithEmailPresenter()
        presenter.view = signInWithEmailViewController
        presenter.router = self
        presenter.analytics = self.analyticsRepository
        
        let interactor = SigninWithEmailInteractor()
        interactor.output = presenter
        interactor.sessionManager = self.sessionManager
        
        presenter.interactor = interactor
        signInWithEmailViewController.output = presenter
        viewController.show(signInWithEmailViewController, sender: nil)
    }
    
    @objc func close() {
        self.parent?.navigationController?.popViewController(animated: true)
    }
    
}
