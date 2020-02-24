//
//  EditProfileEditProfileInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import RxSwift

class EditProfileInteractor: EditProfileInteractorInput {

    var disposeBag = DisposeBag()
    weak var output: EditProfileInteractorOutput!
    var repository: UserRepository?
    var sessionManager: SessionManager?
    
    func fetchUser() {
        if let user = try? self.sessionManager?.user.value() {
            self.output.userReady(user)
        } else {
            self.output.fetchUserFailed()
        }
    }
    
    func updateUser(name: String, newPassword: String?) {
        self.repository?.updateUser(name, new_password: newPassword).subscribe(onNext: { (user) in
            self.output.userUpdated(user)
        }, onError: { (error) in
            self.output.failedToUpdateUser(error: error)
        }).disposed(by: self.disposeBag)
    }
}
