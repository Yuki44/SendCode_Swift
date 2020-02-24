//
//  DashboardDashboardInteractor.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import RxSwift

class DashboardInteractor: DashboardInteractorInput {
    var disposeBag = DisposeBag()

    var repository: TransactionRepository!
    weak var output: DashboardInteractorOutput!

    func fetchTransactions() {
        self.repository.getTransactions().subscribe(onNext: { (transactions) in
            self.output.loadedTransactions(transactions)
        }, onError: { (error) in
            self.output.failedLoadingTransactions(error: error)
        }).disposed(by: self.disposeBag)
    }
}
