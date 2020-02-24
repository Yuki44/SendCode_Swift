//
//  ServicesServicesRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

class ServicesRouter: ServicesRouterInput, TabbedRouter {
    
    var navController: UINavigationController?
    var repository: DataRepository!
    var sessionManager: SessionManager!
    
    init(repository: DataRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func start() {
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .grouped
        }
        
        let controller = ServicesViewController(style: style)
        
        let presenter = ServicesPresenter()
        presenter.view = controller
        presenter.router = self
        
        let interactor = ServicesInteractor()
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
    
}
