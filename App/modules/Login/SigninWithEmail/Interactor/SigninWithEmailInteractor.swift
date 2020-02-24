//
//  SigninWithEmailSigninWithEmailInteractor.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import RxSwift

class SigninWithEmailInteractor: SigninWithEmailInteractorInput {

    weak var output: SigninWithEmailInteractorOutput!
    var sessionManager: SessionManager!
    
    var disposeBag = DisposeBag()

    func signInWith(email: String, password: String) {
        self.sessionManager.login(email: email, password: password)
            .subscribe(onError: { [weak self] (error) in
                self?.output.singInFailed(error: error)
            }).disposed(by: self.disposeBag)
    }
}
