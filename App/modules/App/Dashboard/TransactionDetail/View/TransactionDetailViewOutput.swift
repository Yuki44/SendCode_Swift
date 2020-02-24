//
//  TransactionDetailTransactionDetailViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol TransactionDetailViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func fetchCar(id: Int)
    func cancelPressed()
    func acceptTransaction(_ transactionModel: TransactionModel)
}
