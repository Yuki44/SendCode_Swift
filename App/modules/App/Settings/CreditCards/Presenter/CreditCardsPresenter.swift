//
//  CreditCardsCreditCardsPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class CreditCardsPresenter: CreditCardsModuleInput, CreditCardsViewOutput, CreditCardsInteractorOutput {

    weak var view: CreditCardsViewInput!
    var interactor: CreditCardsInteractorInput!
    var router: CreditCardsRouterInput!

    func viewIsReady() {
        self.refreshRequested()
        self.view.setupInitialState()
    }
    
    func addCreditCardPressed() {
        self.router.routeToAddCreditCard()
    }
    
    func refreshRequested() {
        self.interactor.fetchCreditCards()
    }
    
    func didFetchCreditCards(_ cards: [CreditCardModel]) {
        self.view.displayCreditCards(cards)
    }
    
    func failedToFetchCreditCards(error: Error) {
        self.view.displayError(error)
    }
    
    func destroyCreditCardRequested(creditCardModel: CreditCardModel) {
        self.interactor.destroyCreditCard(creditCardModel: creditCardModel)
    }
    
    func didDestroyCreditCard(_ car: CreditCardModel) {
        self.interactor.fetchCreditCards()
    }
    
    func failedToDestroyCreditCard(error: Error) {
        self.view.displayError(error)
    }
}
