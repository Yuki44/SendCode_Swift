//
//  CarsCarsViewInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol CarsViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayCars(_ cars: [CarModel])
    func displayError(_ error: Error)
}
