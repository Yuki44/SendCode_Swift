//
//  TermsAndConditionsTermsAndConditionsRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class TermsAndConditionsRouter: TermsAndConditionsRouterInput {

    init() {
    }

    func start(from viewController: UIViewController) {

        let controller = TermsAndConditionsViewController()

        let presenter = TermsAndConditionsPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = TermsAndConditionsInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        controller.output = presenter

        viewController.show(controller, sender: nil)
    }

}
