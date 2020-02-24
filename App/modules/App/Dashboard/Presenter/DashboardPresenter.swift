//
//  DashboardDashboardPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

class DashboardPresenter: DashboardModuleInput, DashboardViewOutput, DashboardInteractorOutput {

    weak var view: DashboardViewInput!
    var interactor: DashboardInteractorInput!
    var router: DashboardRouterInput!

    func viewIsReady() {
        self.refreshRequested()
        self.view.setupInitialState()
    }
    
    func loadedTransactions(_ transactions: [TransactionModel]) {
        self.view.displayTransactions(transactions)
    }
    
    func failedLoadingTransactions(error: Error) {
        self.view.displayError(error)
    }
    
    func refreshRequested() {
        self.interactor.fetchTransactions()
    }
    
    func transactionDetailsPressed(transactionModel: TransactionModel) {
        self.router.routeToTransactionDetail(transactionModel: transactionModel)
    }
    
    func pendingTransactionDetailPressed(transactionModel: TransactionModel) {
        self.router.routeToPendingTransactionDetail(transactionModel: transactionModel)
    }
    
}
