//
//  DashboardDashboardViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol DashboardViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    func refreshRequested()
    func pendingTransactionDetailPressed(transactionModel: TransactionModel)
    func transactionDetailsPressed(transactionModel: TransactionModel)
}
