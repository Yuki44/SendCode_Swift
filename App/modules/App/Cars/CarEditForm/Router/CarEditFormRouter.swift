//
//  CarEditFormCarEditFormRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

protocol CarEditFormDelegate {
    func carEditFormFinished()
}

class CarEditFormRouter: CarEditFormRouterInput {
  
    var carModel: CarModel!
    var repository: DataRepository!
    
    var delegate: CarEditFormDelegate
    
    weak var view: UIViewController?
    
    init(carModel: CarModel, repository: DataRepository, finishedDelegate: CarEditFormDelegate) {
        self.carModel = carModel
        self.repository = repository
        self.delegate = finishedDelegate
    }

    func start(from viewController: UIViewController) {

        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .grouped
        }
        
        let controller = CarEditFormViewController(style: style)
        controller.carModel = self.carModel
        self.view = controller
        
        let presenter = CarEditFormPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = CarEditFormInteractor()
        interactor.output = presenter
        interactor.repostiroy = self.repository

        presenter.interactor = interactor
        controller.output = presenter

        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true

        viewController.present(navController, animated: true, completion: nil)
    }
    
    func carEditFormFinished() {
        self.delegate.carEditFormFinished()
    }
    
    func routeToManageCreditCards() {
        let router = CreditCardsRouter(repository: self.repository)
        router.start(from: self.view!)
    }
}
