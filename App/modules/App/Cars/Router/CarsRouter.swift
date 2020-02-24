//
//  CarsCarsRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

class CarsRouter: CarsRouterInput, TabbedRouter {

    var navController: UINavigationController?
    var repository: DataRepository!
    var sessionManager: SessionManager!
    
    var carEditFormDelegate: CarEditFormDelegate?
    
    init(repository: DataRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func start() {
        let controller = CarsViewController()
        self.carEditFormDelegate = controller
        
        let presenter = CarsPresenter()
        presenter.view = controller
        presenter.router = self
        
        let interactor = CarsInteractor()
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
    
    func routeToAddCar() {
        let router = CarEditFormRouter(carModel: CarModel(),
                                       repository: self.repository,
                                       finishedDelegate: self.carEditFormDelegate!)
        
        router.start(from: self.navController!)
    }
    
    func routeToEditCar(_ carModel: CarModel) {
        let router = CarEditFormRouter(carModel: carModel,
                                       repository: self.repository,
                                       finishedDelegate: self.carEditFormDelegate!)
        router.start(from: self.navController!)
    }
}
