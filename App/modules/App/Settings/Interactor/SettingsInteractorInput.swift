//
//  SettingsSettingsInteractorInput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsInteractorInput {
    
    func fetchUser()
    func uploadAvatar(image: UIImage)
}
