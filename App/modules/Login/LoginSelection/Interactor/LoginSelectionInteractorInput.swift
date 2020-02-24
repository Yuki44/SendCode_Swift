//
//  LoginSelectionLoginSelectionInteractorInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import UIKit

protocol LoginSelectionInteractorInput {

    func inititateFacebookLogin(from viewController: UIViewController)
    func inititateAppleLogin(from viewController: UIViewController)
}
