//
//  TransactionRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol TransactionRepository {
    func getTransactions() -> Observable<[TransactionModel]>
    func acceptTransaction(_ transaction: TransactionModel) -> Observable<TransactionModel>
}

extension DataRepository: TransactionRepository {
    func getTransactions() -> Observable<[TransactionModel]> {
        let request = DataRepositoryRequest<TransactionModel>(method: .get,
                                                       endpoint: "carpay/transactions",
                                                       params: nil,
                                                       authorizationNeeded: true)
        
        return self.performRequest(request)
    }
    
    func acceptTransaction(_ transaction: TransactionModel) -> Observable<TransactionModel> {
        let request = DataRepositoryRequest<TransactionModel>(method: .patch,
                                                      endpoint: "carpay/transactions/accept/\(transaction.id)",
            params: nil,
            authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (transactions) -> Observable<TransactionModel> in
            return Observable<TransactionModel>.of(transactions.first!)
        }
    }
}
