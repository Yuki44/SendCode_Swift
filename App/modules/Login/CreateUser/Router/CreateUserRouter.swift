//
//  CreateUserCreateUserRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class CreateUserRouter: CreateUserRouterInput {

    weak var parent: UIViewController?
    var sessionManager: SessionManager
    var analyticsRepository: AnalyticsRepository!

    init(sessionManager: SessionManager, analyticsRepository: AnalyticsRepository) {
        self.sessionManager = sessionManager
        self.analyticsRepository = analyticsRepository
    }
    
    func start(from viewController: UIViewController) {
        self.parent = viewController
        
        let createUserViewController = CreateUserViewController()
        
        let presenter = CreateUserPresenter()
        presenter.view = createUserViewController
        presenter.router = self
        presenter.analytics = self.analyticsRepository
        
        let interactor = CreateUserInteractor()
        interactor.output = presenter
        interactor.sessionManager = self.sessionManager
        
        presenter.interactor = interactor
        createUserViewController.output = presenter
        
        viewController.show(createUserViewController, sender: nil)
    }
    
    func close() {
        self.parent?.navigationController?.popViewController(animated: true)
    }
}
