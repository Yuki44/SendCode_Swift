//
//  ServicesServicesViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

protocol ServicesViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    func updateIsEnabled(_ isEnabled: Bool, for service: ServiceModel)
}
