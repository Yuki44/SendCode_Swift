//
//  SettingsSettingsInteractorOutput.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

protocol SettingsInteractorOutput: class {

    func userReady(_ user: UserModel)
    func fetchUserFailed()
    
    func uploadAvatarFinished(user: UserModel)
    func uploadAvatarFailed(error: Error)
}
