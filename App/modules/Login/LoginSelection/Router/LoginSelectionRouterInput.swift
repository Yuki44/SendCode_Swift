//
//  LoginSelectionLoginSelectionRouterInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

protocol LoginSelectionRouterInput {
    func navigateToEmailSignIn(from viewController: UIViewController)
    func navigateToCreateUser(from viewController: UIViewController)
}
