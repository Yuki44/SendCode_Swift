//
//  CarsCarsRouterInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol CarsRouterInput {
    func routeToAddCar()
    func routeToEditCar(_ carModel: CarModel)
}
