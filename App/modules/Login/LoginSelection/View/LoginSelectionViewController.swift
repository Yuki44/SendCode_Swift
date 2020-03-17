//
//  LoginSelectionLoginSelectionViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseUI
import RxGesture
import SnapKit
import SwiftRichString


class LoginSelectionViewController: UIViewController, LoginSelectionViewInput, FUIAuthDelegate {
    
    // MARK: Variables
    var output: LoginSelectionViewOutput?
    var disposeBag = DisposeBag()
    var signInButton: LoginButton?
    var logoView: UIImageView!
    
    // MARK: Constants
    let headerLabel = UILabel()
    let authUI = FUIAuth.defaultAuthUI()
    let terms = UITextView.temrs()
    let loginButton = LoginButton.login()
    let errorLabel = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // necessary to deinit the notification center
         deinit {
             NotificationCenter.default.removeObserver(self)
         }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        self.authUI?.delegate = self
        configureProviders()
        self.view.backgroundColor = .white
        setSubviews()
        setWelcomeHeader()
        setTerms()
        setLogin()
        NotificationCenter.default.addObserver(self, selector: #selector(cleanView), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setSubviews() {
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.terms)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.errorLabel)
    }
    
    /// Configure the welcome message and the logo image
    func setWelcomeHeader() {
        // Header
        self.headerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(35)
        }
        self.headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.headerLabel.textColor = UIColor.darkGray
        self.headerLabel.text = "Welcome to Send Code!".localize()
        
        // Logo
        self.logoView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(self.logoView)
        self.logoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(45)
            make.height.equalTo(180)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
        }
    }
    
    /// Configure the constraints for the terms of usage of the app
    func setTerms() {
        // Terms
        self.terms.snp.makeConstraints { (make) in
            make.bottomMargin.equalToSuperview().offset(-28)
            make.width.equalTo(258)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
    }
    
    func setLogin() {
        // loginButton
        self.signInButton = self.loginButton
        self.loginButton.addTarget(self, action: #selector(self.startLogin), for: .touchUpInside)
        self.loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.terms.snp.top).offset(-65)
            make.width.equalToSuperview().offset(-35)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        //errorLabel
        self.errorLabel.text = ""
        self.errorLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.errorLabel.adjustsFontForContentSizeCategory = true
        self.errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.errorLabel.numberOfLines = 0
        self.errorLabel.textAlignment = .center
        self.errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginButton.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-25)
        }
    }
    
    func configureProviders() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth()
        ]
        self.authUI?.providers = providers
    }
    
    @objc func startLogin() {
        self.errorLabel.text = ""
        let authViewController = (self.authUI?.authViewController())!
        authViewController.modalPresentationStyle = .popover
        self.present(authViewController, animated: true, completion: nil)
    }
    
    /// Handling of errors
    /// - Parameters:
    ///   - authUI: Firebase auth
    ///   - user: In case it did sign in
    ///   - error: Any error
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if((error) != nil){
        self.errorLabel.text = String(error?.localizedDescription ?? "Something went wrong").localize()
        }
        if((user) != nil) {
            print(user as Any)
        }
    }
    
    /// Handler for the result of the Google and Facebook sign-up flows
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    // MARK: LoginSelectionViewInput
    func setupInitialState() {
        
    }
    
    /// Not being used at the moment
    func displayError(_ error: Error) {
        self.showError(error: error)
            .subscribe(onNext: { [weak self] _ in
                guard `self` != nil else {return}
                //                guard let self = `self` else {return}
                //                self.facebookButton?.setIsLoading(false)
            }).disposed(by: self.disposeBag)
    }
    
    /// called when the view minimizes so the error is not shown all the time
   @objc func cleanView() {
        self.errorLabel.text = ""
    }
    

}
