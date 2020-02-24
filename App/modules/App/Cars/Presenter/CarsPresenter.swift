//
//  CarsCarsPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class CarsPresenter: CarsModuleInput, CarsViewOutput, CarsInteractorOutput {

    weak var view: CarsViewInput!
    var interactor: CarsInteractorInput!
    var router: CarsRouterInput!

    func viewIsReady() {
        self.refreshRequested()
        self.view.setupInitialState()
    }
    
    func addCarPressed() {
        self.router.routeToAddCar()
    }
    
    func refreshRequested() {
        self.interactor.fetchCars()
    }
    
    func didFetchCars(_ cars: [CarModel]) {
        self.view.displayCars(cars)
    }
    
    func failedToFetchCars(error: Error) {
        self.view.displayError(error)
    }
    
    func editCarPressed(carModel: CarModel) {
        self.router.routeToEditCar(carModel)
    }
    
    func destroyCarRequested(carModel: CarModel) {
        self.interactor.destroyCar(carModel: carModel)
    }
    
    func didDestroyCar(_ car: CarModel) {
        self.interactor.fetchCars()
    }
    
    func failedToDestroyCar(error: Error) {
        self.view.displayError(error)
    }
}
