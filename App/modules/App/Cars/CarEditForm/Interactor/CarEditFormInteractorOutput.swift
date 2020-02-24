//
//  CarEditFormCarEditFormInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

protocol CarEditFormInteractorOutput: class {
    func didFetchCreditCards(cards: [CreditCardModel])
    func failedToFetchCreditCards(error: Error)
    func sucessfullySavedCar(_ carModel: CarModel)
    func failedToSaveCar(error: Error)
}
