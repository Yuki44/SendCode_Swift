//
//  DashboardDashboardRouter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class DashboardRouter: DashboardRouterInput, TabbedRouter {

    var navController: UINavigationController?
    var repository: DataRepository!
    var sessionManager: SessionManager!
    
    var acceptModeDelegate: TransactionDetailRouterDelegate?
    
    init(repository: DataRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func start() {
        let controller = DashboardViewController()
        self.acceptModeDelegate = controller
        
        let presenter = DashboardPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = DashboardInteractor()
        interactor.output = presenter
        interactor.repository = self.repository
        
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
    
    func routeToTransactionDetail(transactionModel: TransactionModel) {
        let router = TransactionDetailRouter(mode: .readOnly, transactionModel: transactionModel, repository: self.repository)
        router.start(from: self.navController!)
    }
    
    func routeToPendingTransactionDetail(transactionModel: TransactionModel) {
        let router = TransactionDetailRouter(mode: .acceptMode, transactionModel: transactionModel, repository: self.repository)
        router.acceptModeFinishDelegate = self.acceptModeDelegate
        router.start(from: self.navController!)
    }
}
