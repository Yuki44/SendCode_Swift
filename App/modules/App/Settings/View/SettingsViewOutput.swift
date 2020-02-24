//
//  SettingsSettingsViewOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

protocol SettingsViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    func logoutPressed()
    func menuItemPressed(item: SettingsMenuItem)
    func uploadNewAvatar(image: UIImage)
}
