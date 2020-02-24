//
//  AddCreditCardAddCreditCardViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol AddCreditCardViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func saveCardRequested(card: CreditCardModel)
}
