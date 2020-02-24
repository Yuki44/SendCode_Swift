//
//  AddCreditCardAddCreditCardPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class AddCreditCardPresenter: AddCreditCardModuleInput, AddCreditCardViewOutput, AddCreditCardInteractorOutput {

    weak var view: AddCreditCardViewInput!
    var interactor: AddCreditCardInteractorInput!
    var router: AddCreditCardRouterInput!

    func viewIsReady() {
        self.view.setupInitialState()
    }
    
    func saveCardRequested(card: CreditCardModel) {
        self.interactor.createCard(card)
    }
    
    func didCreatedCreditCard(_ card: CreditCardModel) {
        self.router.addCreditCardFinished()
    }
    
    func failedToCreateCreditCard(error: Error) {
        self.view.displayError(error)
    }
    
}
