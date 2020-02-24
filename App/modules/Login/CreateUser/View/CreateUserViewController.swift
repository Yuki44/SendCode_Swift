//
//  CreateUserCreateUserViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class CreateUserViewController: UIViewController, CreateUserViewInput {

    var output: CreateUserViewOutput!
    
    var disposeBag = DisposeBag()
    
    var name: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var email: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var passwordOne: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var passwordTwo: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    var createUserButton: RoundedButton?

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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20.0)
            make.width.equalTo(34)
            make.height.equalTo(44)
        }
        
        backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        backButton.addTarget(self.output, action: #selector(self.output.close), for: .touchUpInside)
        
        // Header
        var headerLabelTopOffset = 126.0
        var headerLeaberLeftOffset = 27.0
        UIDevice.onIphone5 {
            headerLabelTopOffset = 48.0
            headerLeaberLeftOffset = 66.0
        }
        
        let headerLabel = UILabel()
        self.view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerLeaberLeftOffset)
            make.top.equalTo(headerLabelTopOffset)
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Opret Profil".localize()
        
        // Name field
        let nameField = BigWhiteTextField()
        self.view.addSubview(nameField)
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.height.equalTo(47)
        }
        
        nameField.placeholder = "Skriv navn".localize()
        nameField.keyboardType = .namePhonePad
        nameField.textContentType = .name
        nameField.rx.text.subscribe(onNext: { [weak self] (text) in
            self?.name.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
        
        // Email Field
        let emailField = BigWhiteTextField()
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(nameField.snp.bottom).offset(15)
            make.height.equalTo(47)
        }
        
        emailField.placeholder = "Skriv E-mail".localize()
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.rx.text.subscribe(onNext: { [weak self] (text) in
            self?.email.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
        
        // Password 1
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
            self?.passwordOne.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
        
        let passwordTwoField = BigWhiteTextField()
        self.view.addSubview(passwordTwoField)
        passwordTwoField.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(passwordField.snp.bottom).offset(15)
            make.height.equalTo(47)
        }
        
        passwordTwoField.placeholder = "Gentag Adgangskode".localize()
        passwordTwoField.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            passwordTwoField.textContentType = .newPassword
        } else {
            // Fallback on earlier versions
        }
        passwordTwoField.rx.text.subscribe(onNext: { [weak self] (text) in
            self?.passwordTwo.onNext(text ?? "")
        }).disposed(by: self.disposeBag)
        
        // Terms
        let terms = UITextView.temrs()
        self.view.addSubview(terms)
        terms.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTwoField.snp.bottom).offset(31)
            make.width.equalTo(258)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
        
        // Action button
        var createUserButtonOffset = -91.0
        UIDevice.onIphone5 {
            createUserButtonOffset = -20.0
        }
        self.createUserButton = RoundedButton()
        self.view.addSubview(self.createUserButton!)
        self.createUserButton!.snp.makeConstraints { (make) in
            make.bottom.equalTo(createUserButtonOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(191)
            make.height.equalTo(44)
        }
        
        self.createUserButton?.setTitle("Opret Profil".localize(), for: .normal)
        self.createUserButton?.rx.tap.bind { [weak self] in
            if let name = try? self?.name.value(),
                let email = try? self?.email.value(),
                let password = try? self?.passwordOne.value() {
                
                self?.createUserButton?.setLoading(true)
                self?.output.createUserPressed(name: name, email: email, password: password)
            }
        }.disposed(by: self.disposeBag)
        
        Observable
            .combineLatest([self.name, self.email, self.passwordOne, self.passwordTwo])
            .subscribe(onNext: { [weak self] (results) in
                let allFilled = results.filter { (text) -> Bool in
                    return text.isEmpty
                }.count == 0
                
                let emailValidates = results[1].contains("@") && results[1].contains(".")
                let passwordMatch = results[2] == results[3]
                
                self?.createUserButton?.setEnabled(allFilled && emailValidates && passwordMatch)
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

    // MARK: CreateUserViewInput
    func setupInitialState() {
        
    }

    func displayError(_ error: Error) {
        self.showError(error: error)
            .subscribe(onNext: { [weak self] _ in
                self?.createUserButton?.setLoading(false)
            }).disposed(by: self.disposeBag)
    }
}
