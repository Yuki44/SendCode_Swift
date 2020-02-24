//
//  SettingsSettingsInteractor.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import RxSwift
import UIKit

class SettingsInteractor: SettingsInteractorInput {
    var disposeBag = DisposeBag()
    weak var output: SettingsInteractorOutput!
    var repository: DataRepository?
    var sessionManager: SessionManager?
    
    func fetchUser() {
        if let user = try? self.sessionManager?.user.value() {
            self.output.userReady(user)
        } else {
            self.output.fetchUserFailed()
        }
    }
    
    func uploadAvatar(image: UIImage) {
        self.repository?.updateAvatar(image).subscribe(onNext: { (user) in
            self.output.uploadAvatarFinished(user: user)
        }, onError: { (error) in
            self.output.uploadAvatarFailed(error: error)
        })
    }
}
