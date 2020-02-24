//
//  AddCreditCardAddCreditCardInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol AddCreditCardInteractorOutput: class {
    func didCreatedCreditCard(_ card: CreditCardModel)
    func failedToCreateCreditCard(error: Error)
}
