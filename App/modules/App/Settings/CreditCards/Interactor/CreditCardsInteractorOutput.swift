//
//  CreditCardsCreditCardsInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol CreditCardsInteractorOutput: class {
    func didFetchCreditCards(_ cards: [CreditCardModel])
    func failedToFetchCreditCards(error: Error)
    func didDestroyCreditCard(_ card: CreditCardModel)
    func failedToDestroyCreditCard(error: Error)
}
