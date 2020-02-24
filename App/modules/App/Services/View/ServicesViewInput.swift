//
//  ServicesServicesViewInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol ServicesViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayServices(_ services: [ServiceModel])
    func displayError(_ error: Error)
}
