//
//  CreateUserCreateUserInteractor.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import RxSwift

class CreateUserInteractor: CreateUserInteractorInput {

    weak var output: CreateUserInteractorOutput!
    
    var disposeBag = DisposeBag()
    var sessionManager: SessionManager!

    func createUser(name: String, email: String, password: String) {
        self.sessionManager
            .createUser(name: name,
                        email: email,
                        password: password)
            .subscribe(onError: { [weak self] (error) in
                self?.output.error(error)
            }).disposed(by: self.disposeBag)
    }
}
