//
//  CarsCarsViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol CarsViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func addCarPressed()
    func refreshRequested()
    
    func editCarPressed(carModel: CarModel)
    func destroyCarRequested(carModel: CarModel)
}
