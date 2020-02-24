//
//  EditProfileEditProfileRouter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

protocol EditProfileFormDelegate {
    func editProfileRouterFinished(user: UserModel)
}

class EditProfileRouter: EditProfileRouterInput {

    var sessionManager: SessionManager!
    var repository: UserRepository!
    var finishDelegate: EditProfileFormDelegate
    
    init(sessionManager: SessionManager, repository: UserRepository, finishDelegate: EditProfileFormDelegate) {
        self.sessionManager = sessionManager
        self.repository = repository
        self.finishDelegate = finishDelegate
    }

    func start(from viewController: UIViewController) {

        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        let controller = EditProfileViewController(style: style)

        let presenter = EditProfilePresenter()
        presenter.view = controller
        presenter.router = self

        let interactor = EditProfileInteractor()
        interactor.output = presenter
        interactor.repository = self.repository
        interactor.sessionManager = self.sessionManager


        presenter.interactor = interactor
        controller.output = presenter

        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true
        
        viewController.present(navController, animated: true, completion: nil)
    }

    func editProfileRouterFinished(user: UserModel) {
        self.finishDelegate.editProfileRouterFinished(user: user)
    }
}
