//
//  DashboardDashboardInteractorOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

protocol DashboardInteractorOutput: class {
    func loadedTransactions(_ transactions: [TransactionModel])
    func failedLoadingTransactions(error: Error)
}
