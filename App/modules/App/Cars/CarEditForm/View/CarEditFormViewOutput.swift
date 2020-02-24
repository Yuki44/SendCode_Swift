//
//  CarEditFormCarEditFormViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol CarEditFormViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    func saveCarRequested(_ carModel: CarModel)
    func cancelEditCarFormPressed()
    func manageCreditCardsPressed()
    func fetchCreditCardsRequested()
}
