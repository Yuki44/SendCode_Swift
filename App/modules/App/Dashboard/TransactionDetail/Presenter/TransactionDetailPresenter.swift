//
//  TransactionDetailTransactionDetailPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class TransactionDetailPresenter: TransactionDetailModuleInput, TransactionDetailViewOutput, TransactionDetailInteractorOutput {

    weak var view: TransactionDetailViewInput!
    var interactor: TransactionDetailInteractorInput!
    var router: TransactionDetailRouterInput!

    func viewIsReady() {
        self.view.setupInitialState()
    }
    
    func fetchCar(id: Int) {
        self.interactor.fetchCar(id: id)
    }
    
    func didFetchCar(_ car: CarModel) {
        self.view.displayCar(car)
    }
    
    func failedToFetchCar(error: Error) {
        
    }
    
    func cancelPressed() {
        self.router.acceptModeCancelled()
    }
    
    func acceptTransaction(_ transactionModel: TransactionModel) {
        self.interactor.acceptTransaction(transactionModel)
    }

    func didAcceptTransaction(_ transaction: TransactionModel) {
        self.router.acceptModeFinished()
    }
    
    func failedToAcceptTransaction(error: Error) {
        self.view.displayError(error)
    }
}
