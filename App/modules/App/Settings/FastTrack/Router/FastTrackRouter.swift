//
//  FastTrackFastTrackRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

class FastTrackRouter: FastTrackRouterInput {

    var repository: FastTrackRepository!
    
    init(repository: FastTrackRepository) {
        self.repository = repository
    }

    func start(from viewController: UIViewController) {
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        let controller = FastTrackViewController(style: style)

        let presenter = FastTrackPresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = FastTrackInteractor()
        interactor.output = presenter
        interactor.repository = self.repository

        presenter.interactor = interactor
        controller.output = presenter

        viewController.show(controller, sender: nil)
    }
}
