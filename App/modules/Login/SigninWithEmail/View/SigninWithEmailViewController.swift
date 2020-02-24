//
//  SigninWithEmailSigninWithEmailViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import SwiftRichString
import RxGesture

class SigninWithEmailViewController: UIViewController, SigninWithEmailViewInput {

    var output: SigninWithEmailViewOutput!

    var disposeBag = DisposeBag()
    
    var email: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var password: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    var signInButton: RoundedButton?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        // Background
        /*let background = UIImageView(image: UIImage(named: "login_bg"))
        background.contentMode = .scaleAspectFill
        self.view.addSubview(background)
        background.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }*/
        self.view.backgroundColor = .black
        
        // Back arrow
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(34)
            make.height.equalTo(44)
        }
        
        backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        backButton.addTarget(self.output, action: #selector(self.output.close), for: .touchUpInside)
        
        // Header
        let headerLabel = UILabel()
        self.view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(27)
            make.top.equalTo(126)
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Sign in med E-mail".localize()
        
        // Name field
        let emailField = BigWhiteTextField()
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.height.equalTo(47)
        }
        
        emailField.placeholder = "Skriv E-mail".localize()
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.rx.text.subscribe(onNext: { [weak self] (text) in
            self?.email.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
        
        // Password Field
        let passwordField = BigWhiteTextField()
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.height.equalTo(47)
        }
        
        passwordField.placeholder = "Skriv Adgangskode".localize()
        passwordField.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            passwordField.textContentType = .newPassword
        } else {
            // Fallback on earlier versions
        }
        passwordField.rx.text.subscribe(onNext: { [weak self] (text) in
            self?.password.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
     
        // Action button
        self.signInButton = RoundedButton()
        self.view.addSubview(self.signInButton!)
        self.signInButton!.snp.makeConstraints { (make) in
            make.bottom.equalTo(-91)
            make.centerX.equalToSuperview()
            make.width.equalTo(191)
            make.height.equalTo(44)
        }
        
        self.signInButton?.setTitle("Sign in".localize(), for: .normal)
        self.signInButton?.rx.tap.bind { [weak self] in
            if let email = try? self?.email.value(),
                let password = try? self?.password.value() {
                self?.signInButton?.setLoading(true)
                self?.output.signInWith(email: email, password: password)
            }
        }.disposed(by: self.disposeBag)
        
        Observable
            .combineLatest([self.email, self.password])
            .subscribe(onNext: { [weak self] (results) in
                let allFilled = results.filter { (text) -> Bool in
                    return text.isEmpty
                }.count == 0
                
                let emailValidates = results[0].contains("@") && results[0].contains(".")
                
                self?.signInButton?.setEnabled(allFilled && emailValidates)
            }).disposed(by: self.disposeBag)
        
        self.view
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                self?.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
    }


    // MARK: SigninWithEmailViewInput
    func setupInitialState() {
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error)
            .subscribe(onNext: { [weak self] _ in
                self?.signInButton?.setLoading(false)
            }).disposed(by: self.disposeBag)
    }
}
