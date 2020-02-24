//
//  TabbedNavigationTabbedNavigationViewInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

protocol TabbedNavigationViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    func displayRouter(_ router: TabbedRouter)
}
