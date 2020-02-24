//
//  CarsCarsInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol CarsInteractorOutput: class {
    func didFetchCars(_ cars: [CarModel])
    func failedToFetchCars(error: Error)
    func didDestroyCar(_ car: CarModel)
    func failedToDestroyCar(error: Error)
}
