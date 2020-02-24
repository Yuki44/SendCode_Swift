//
//  TransactionDetailTransactionDetailInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol TransactionDetailInteractorOutput: class {
    func didFetchCar(_ car: CarModel)
    func failedToFetchCar(error: Error)
    func didAcceptTransaction(_ transaction: TransactionModel)
    func failedToAcceptTransaction(error: Error)
}
