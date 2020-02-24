//
//  CarEditFormCarEditFormPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class CarEditFormPresenter: CarEditFormModuleInput, CarEditFormViewOutput, CarEditFormInteractorOutput {

    weak var view: CarEditFormViewInput!
    var interactor: CarEditFormInteractorInput!
    var router: CarEditFormRouterInput!

    func viewIsReady() {
        self.view.setupInitialState()
    }
    
    func sucessfullySavedCar(_ carModel: CarModel) {
        self.router.carEditFormFinished()
    }
    
    func cancelEditCarFormPressed() {
        self.router.carEditFormFinished()
    }
    
    func failedToSaveCar(error: Error) {
        self.view.displayError(error)
    }

    func saveCarRequested(_ carModel: CarModel) {
        if carModel.id > 0 {
            self.interactor.updateCar(carModel)
        } else {
            self.interactor.createCar(carModel)
        }
    }
    
    func manageCreditCardsPressed() {
        self.router.routeToManageCreditCards()
    }
    
    func didFetchCreditCards(cards: [CreditCardModel]) {
        self.view.displayCreditCards(cards)
    }
    
    func failedToFetchCreditCards(error: Error) {
        self.view.displayError(error)
        self.view.showNoCreditCards()
    }
    
    func fetchCreditCardsRequested() {
        self.interactor.fetchCreditCards()
    }

}
