//
//  TransactionDetailTransactionDetailInteractorInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol TransactionDetailInteractorInput {
    func fetchCar(id: Int)
    func acceptTransaction(_ transaction: TransactionModel)
}
