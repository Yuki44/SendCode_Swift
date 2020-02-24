//
//  CreditCardsCreditCardsRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

class CreditCardsRouter: CreditCardsRouterInput {

    var repository: DataRepository!
    var addCreditCardDelegate: AddCreditCardDelegate?
    weak var parent: UIViewController?
    
    init(repository: DataRepository) {
        self.repository = repository
    }

    func start(from viewController: UIViewController) {

        let controller = CreditCardsViewController()
        self.addCreditCardDelegate = controller

        let presenter = CreditCardsPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = CreditCardsInteractor()
        interactor.output = presenter
        interactor.repository = self.repository

        presenter.interactor = interactor
        controller.output = presenter

        viewController.show(controller, sender: nil)
        self.parent = viewController
    }

    func routeToAddCreditCard() {
        let router = AddCreditCardRouter(repository: self.repository, finishDelegate: self.addCreditCardDelegate!)
        router.start(from: self.parent!)
    }
}
