//
//  LoginSelectionLoginSelectionPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import UIKit

fileprivate enum AnalyticEvents: String {
    case ready = "Login Selection Ready"
    case facebook = "Logged In With Faceboook"
    case apple = "Logged In With Apple"
    case loginFailed = "Login Failed"
    case loginCancelled = "Login Cancelled"
}

class LoginSelectionPresenter: LoginSelectionModuleInput, LoginSelectionViewOutput, LoginSelectionInteractorOutput {
    
    weak var view: LoginSelectionViewInput!
    var interactor: LoginSelectionInteractorInput!
    var router: LoginSelectionRouterInput!
    var analytics: AnalyticsRepository!

    func viewIsReady() {
        self.view.setupInitialState()
        self.analytics.logEvent(event: AnalyticEvents.ready.rawValue)
    }
    
    @objc func signInWithEmailPressed() {
        self.router.navigateToEmailSignIn(from: self.view)
    }
    
    func signInWithFacebookPressed(from viewController: UIViewController) {
        self.analytics.logEvent(event: AnalyticEvents.facebook.rawValue)
        self.interactor.inititateFacebookLogin(from: viewController)
    }
    
    func signInWithApplePressed(from viewController: UIViewController) {
        self.analytics.logEvent(event: AnalyticEvents.apple.rawValue)
        self.interactor.inititateAppleLogin(from: viewController)
    }
    
    @objc func createUserPressed() {
        self.router.navigateToCreateUser(from: self.view)
    }
    
    func loginFailedWithError(_ error: Error) {
        self.analytics.logEvent(event: AnalyticEvents.loginFailed.rawValue)
        self.view.displayError(error)
    }
    
    func loginCancelled() {
        self.analytics.logEvent(event: AnalyticEvents.loginCancelled.rawValue)
        self.view.loginCancelled()
    }
}
