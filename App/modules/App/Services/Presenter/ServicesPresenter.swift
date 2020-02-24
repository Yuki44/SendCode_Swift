//
//  ServicesServicesPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

class ServicesPresenter: ServicesModuleInput, ServicesViewOutput, ServicesInteractorOutput {

    weak var view: ServicesViewInput!
    var interactor: ServicesInteractorInput!
    var router: ServicesRouterInput!

    func viewIsReady() {
        self.view.setupInitialState()
        self.interactor.fetchServices()
    }
    
    func didFetchServices(_ services: [ServiceModel]) {
        self.view.displayServices(services)
    }
    
    func failedToFetchServices(error: Error) {
        self.view.displayError(error)
    }
    
    func updateIsEnabled(_ isEnabled: Bool, for service: ServiceModel) {
        self.interactor.updateIsEnabled(isEnabled, for: service)
    }
    
    func failedToUpdateService(error: Error) {
        self.view.displayError(error)
    }
    
    func didUpdateService(_ service: ServiceModel) {
        // Ignore?
    }
}
