//
//  TabbedNavigationTabbedNavigationViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol TabbedNavigationViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */
    

    func viewIsReady()
    func changeRouter(_ identifier: TabIdentifier)
    func logout()
}
