//
//  LoginSelectionLoginSelectionInteractor.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import FBSDKLoginKit
import UIKit
import RxSwift
import AuthenticationServices

class LoginSelectionInteractor: NSObject, LoginSelectionInteractorInput {
    
    enum LoginError: Error {
        case tokenNotFound
        case onlyOnIOS13
    }

    var disposeBag = DisposeBag()
    weak var output: LoginSelectionInteractorOutput!
    var sessionManager: SessionManager?

    weak var appleSigninPresentationAnchor: ASPresentationAnchor?
    
    func inititateFacebookLogin(from viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: viewController) { [weak self] (result, error) in
            guard let result = result else {
                log.warning("[facebook] No result found")
                return
            }
            
            if result.isCancelled {
                log.warning("[facebook] cancelled")
                self?.output.loginCancelled()
            } else if let error = error {
                log.warning("[facebook] error: \(error)")
                self?.output.loginFailedWithError(error)
            } else {
                // Login was ok
                if let token = result.token {
                    self?.validateFacebookToken(token.tokenString)
                } else {
                    log.warning("[facebook] error: \(LoginError.tokenNotFound)")
                    self?.output.loginFailedWithError(LoginError.tokenNotFound)
                }
            }
        }
    }
    
    func inititateAppleLogin(from viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            self.appleSigninPresentationAnchor = viewController.view.window!
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            self.output.loginFailedWithError(LoginError.onlyOnIOS13)
        }
    }
    
    private func validateFacebookToken(_ token: String) {
        self.sessionManager?
            .login(facebookToken: token)
            .subscribe(onError: { [weak self] (error) in
                self?.output.loginFailedWithError(error)
            }).disposed(by: self.disposeBag)
    }
}

@available(iOS 13.0, *)
extension LoginSelectionInteractor: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            var name: String = "No Name"
            
            if let fullName = appleIDCredential.fullName {
                var nameComponents: [String] = []
                if let givenName = fullName.givenName {
                    nameComponents.append(givenName)
                }
                
                if let familyName = fullName.familyName {
                    nameComponents.append(familyName)
                }
                
                if nameComponents.count > 0 {
                    name = nameComponents.joined(separator: " ")
                }
            }
            
            if let jwtData = appleIDCredential.identityToken,
                let jwt = String(data: jwtData, encoding: .utf8) {
                self.sessionManager?
                    .login(appleIdentifier: appleIDCredential.user,
                           jwt: jwt,
                           fullName: name)
                    .subscribe(onError: { [weak self] (error) in
                        self?.output.loginFailedWithError(error)
                    }).disposed(by: self.disposeBag)
            } else {
                self.output?.loginFailedWithError(LoginError.tokenNotFound)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.output.loginFailedWithError(error)
    }
}

@available(iOS 13.0, *)
extension LoginSelectionInteractor: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.appleSigninPresentationAnchor!
    }
}
