//
//  TransactionDetailTransactionDetailInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class TransactionDetailInteractor: TransactionDetailInteractorInput {

    weak var output: TransactionDetailInteractorOutput!
    var repository: (CarRepository & TransactionRepository)!
    var disposeBag = DisposeBag()
    
    func fetchCar(id: Int) {
        self.repository.getCar(id: id).subscribe(onNext: { (car) in
            self.output.didFetchCar(car)
        }, onError: { (error) in
            self.output.failedToFetchCar(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func acceptTransaction(_ transaction: TransactionModel) {
        self.repository.acceptTransaction(transaction).subscribe(onNext: { (transaction) in
            self.output.didAcceptTransaction(transaction)
        }, onError: { (error) in
            self.output.failedToAcceptTransaction(error: error)
        }).disposed(by: self.disposeBag)
    }
}
