//
//  CreditCardsCreditCardsViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol CreditCardsViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func addCreditCardPressed()
    func refreshRequested()
    
    func destroyCreditCardRequested(creditCardModel: CreditCardModel)
}
