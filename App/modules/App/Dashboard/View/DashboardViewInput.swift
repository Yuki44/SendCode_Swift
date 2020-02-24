//
//  DashboardDashboardViewInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol DashboardViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayTransactions(_ transactions: [TransactionModel])
    func displayError(_ error: Error)
}
