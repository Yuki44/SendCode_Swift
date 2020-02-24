//
//  CarEditFormCarEditFormViewInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol CarEditFormViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayError(_ error: Error)
    func displayCreditCards(_ cards: [CreditCardModel])
    func showNoCreditCards()
}
