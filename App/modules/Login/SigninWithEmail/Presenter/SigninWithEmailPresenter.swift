//
//  SigninWithEmailSigninWithEmailPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import Foundation

fileprivate enum AnalyticEvents: String {
    case ready = "Sign In With Email Ready"
    case started = "Sign In With Email Pressed"
    case failed = "Sign In With Email Failed"
    case canceled = "Sign In With Email Cancelled"
}

class SigninWithEmailPresenter: SigninWithEmailModuleInput, SigninWithEmailViewOutput, SigninWithEmailInteractorOutput {

    weak var view: SigninWithEmailViewInput!
    var interactor: SigninWithEmailInteractorInput!
    var router: SigninWithEmailRouterInput!
    var analytics: AnalyticsRepository!

    func viewIsReady() {
        self.analytics.logEvent(event: AnalyticEvents.ready.rawValue)
    }
    
    @objc func close() {
        self.analytics.logEvent(event: AnalyticEvents.canceled.rawValue)
        self.router.close()
    }
    
    func signInWith(email: String, password: String) {
        self.analytics.logEvent(event: AnalyticEvents.started.rawValue)
        self.interactor.signInWith(email: email, password: password)
    }
    
    func singInFailed(error: Error) {
        self.analytics.logEvent(event: AnalyticEvents.failed.rawValue)
        self.view.displayError(error)
    }
}
