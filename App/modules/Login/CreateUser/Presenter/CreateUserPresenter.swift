//
//  CreateUserCreateUserPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import Foundation

fileprivate enum AnalyticEvents: String {
    case ready = "Create User Ready"
    case started = "Create User Pressed"
    case failed = "Create User Failed"
    case canceled = "Create User Cancelled"
}

class CreateUserPresenter: CreateUserModuleInput, CreateUserViewOutput, CreateUserInteractorOutput {

    weak var view: CreateUserViewInput!
    var interactor: CreateUserInteractorInput!
    var router: CreateUserRouterInput!
    var analytics: AnalyticsRepository!

    func viewIsReady() {
        self.view.setupInitialState()
        self.analytics.logEvent(event: AnalyticEvents.ready.rawValue)
    }
    
    func createUserPressed(name: String, email: String, password: String) {
        self.analytics.logEvent(event: AnalyticEvents.started.rawValue)
        self.interactor.createUser(name: name,
                                   email: email,
                                   password: password)
    }

    func error(_ error: Error) {
        self.analytics.logEvent(event: AnalyticEvents.failed.rawValue)
        self.view.displayError(error)
    }
    
    @objc func close() {
        self.analytics.logEvent(event: AnalyticEvents.canceled.rawValue)
        self.router.close()
    }
}
