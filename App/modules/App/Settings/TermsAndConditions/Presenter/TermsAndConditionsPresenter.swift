//
//  TermsAndConditionsTermsAndConditionsPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

class TermsAndConditionsPresenter: TermsAndConditionsModuleInput, TermsAndConditionsViewOutput, TermsAndConditionsInteractorOutput {

    weak var view: TermsAndConditionsViewInput!
    var interactor: TermsAndConditionsInteractorInput!
    var router: TermsAndConditionsRouterInput!

    func viewIsReady() {

    }
}
