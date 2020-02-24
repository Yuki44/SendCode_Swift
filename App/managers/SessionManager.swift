//
//  sessionManager.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 23/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class SessionManager {
    enum Status {
        case loggedIn
        case loggedOut
    }
    
    var disposeBag = DisposeBag()
    
    var status: BehaviorSubject<Status> = BehaviorSubject<Status>(value: .loggedOut)
    var user: BehaviorSubject<UserModel?> = BehaviorSubject<UserModel?>(value: nil)
    
    var repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
        
        self.user
            .subscribe(onNext: { (user) in
                self.repository.setAuthorizedUser(user)
                if let u = user {
                    self.validate(user: u)
                }
            }).disposed(by: self.disposeBag)
        
        do {
            let realm = try Realm()
            if let user = realm.objects(UserModel.self).last {
                self.user.onNext(user)
            }
        } catch _ {
            self.logout()
        }
    }
    
    private func validate(user: UserModel) {
        self.repository
            .validateUser(user)
            .subscribe(onNext: { [weak self] (user) in
                self?.status.onNext(.loggedIn)
                }, onError: { [weak self] (error) in
                    log.warning("Validation error: \(error)")
                    self?.logout()
            }).disposed(by: self.disposeBag)
    }
    
    func logout() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
            self.user.onNext(nil)
            self.status.onNext(.loggedOut)
        } catch _ {}
    }
    
    func login(email: String, password: String) -> Observable<UserModel> {
        return self
            .repository
            .login(email: email,
                   password: password)
            .do(onNext: { [weak self] (user) in
                self?.user.onNext(user)
            })
    }
    
    func login(appleIdentifier: String, jwt: String, fullName: String) -> Observable<UserModel> {
        return self
            .repository
            .login(appleIdentifier: appleIdentifier,
                   jwt: jwt,
                   fullName: fullName)
            .do(onNext: { [weak self] (user) in
                self?.user.onNext(user)
            })
    }
    
    func login(facebookToken: String) -> Observable<UserModel> {
        return self
            .repository
            .login(facebookToken: facebookToken)
            .do(onNext: { [weak self] (user) in
                self?.user.onNext(user)
            })
    }
    
    func createUser(name: String, email: String, password: String) -> Observable<UserModel> {
        return self
            .repository
            .createUser(name: name,
                        email: email,
                        password: password)
            .do(onNext: { [weak self] (user) in
                self?.user.onNext(user)
            })
    }
}
