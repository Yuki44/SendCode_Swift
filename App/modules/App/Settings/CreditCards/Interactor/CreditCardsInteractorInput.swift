//
//  CreditCardsCreditCardsInteractorInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol CreditCardsInteractorInput {
    func fetchCreditCards()
    func destroyCreditCard(creditCardModel: CreditCardModel)
}
