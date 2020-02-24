//
//  TransactionDetailTransactionDetailRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import UIKit

protocol TransactionDetailRouterDelegate {
    func transactionDetailRouterCancelled()
    func transactionDetailRouterFinished()
}

enum TransactionDetailMode {
    case readOnly
    case acceptMode
}

class TransactionDetailRouter: TransactionDetailRouterInput {

    var mode: TransactionDetailMode!
    var transactionModel: TransactionModel!
    var repository: (CarRepository & TransactionRepository)!
    var acceptModeFinishDelegate: TransactionDetailRouterDelegate?
    
    init(mode: TransactionDetailMode, transactionModel: TransactionModel, repository: CarRepository & TransactionRepository) {
        self.transactionModel  = transactionModel
        self.repository = repository
        self.mode = mode
    }

    func start(from viewController: UIViewController) {
        let controller = TransactionDetailViewController()
        controller.mode = self.mode
        controller.transactionModel = self.transactionModel
        
        let presenter = TransactionDetailPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = TransactionDetailInteractor()
        interactor.output = presenter
        interactor.repository = self.repository

        presenter.interactor = interactor
        controller.output = presenter

        if self.mode == .readOnly {
            viewController.show(controller, sender: nil)
        } else {
            let navController = UINavigationController(rootViewController: controller)
            navController.navigationBar.prefersLargeTitles = true
            viewController.present(navController, animated: true, completion: nil)
        }
    }
    
    func acceptModeCancelled() {
        self.acceptModeFinishDelegate?.transactionDetailRouterCancelled()
    }
    
    func acceptModeFinished() {
        self.acceptModeFinishDelegate?.transactionDetailRouterFinished()
    }
}
