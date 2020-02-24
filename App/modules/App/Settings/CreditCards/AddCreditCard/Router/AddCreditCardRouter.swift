//
//  AddCreditCardAddCreditCardRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

protocol AddCreditCardDelegate {
    func addCreditCardFinishied()
}

class AddCreditCardRouter: AddCreditCardRouterInput {

    var addCreditCardDelegate: AddCreditCardDelegate!
    var repository: CreditCardRepository!
    
    init(repository: CreditCardRepository, finishDelegate: AddCreditCardDelegate) {
        self.addCreditCardDelegate = finishDelegate
        self.repository = repository
    }

    func start(from viewController: UIViewController) {

        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        let controller = AddCreditCardViewController(style: style)

        let presenter = AddCreditCardPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = AddCreditCardInteractor()
        interactor.output = presenter
        interactor.repository = self.repository
    
        presenter.interactor = interactor
        controller.output = presenter

        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true
        
        viewController.present(navController, animated: true, completion: nil)
    }

    func addCreditCardFinished() {
        self.addCreditCardDelegate.addCreditCardFinishied()
    }
}
