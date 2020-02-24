//
//  LoginSelectionLoginSelectionViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import SwiftRichString

class LoginSelectionViewController: UIViewController, LoginSelectionViewInput {

    var output: LoginSelectionViewOutput!
    var disposeBag = DisposeBag()
    var facebookButton: LoginButton!
    var appleButtton: LoginButton!
    
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
        self.view.backgroundColor = .white
        
        var offset = 86.0
        UIDevice.onIphone5 {
            offset = 26.0
        }
        
        UIDevice.onIphone8 {
            offset = 46.0
        }
        
        // Header
        let headerLabel = UILabel()
        self.view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(27)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(offset)
        }

        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Welcome to Send Code!".localize()
        
        // Email
        let signWithEmailButton = LoginButton.email()
        self.view.addSubview(signWithEmailButton)
        signWithEmailButton.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(47)
        }
        
        signWithEmailButton.addTarget(self.output,
                                      action: #selector(self.output.signInWithEmailPressed),
                                      for: .touchUpInside)
        
        // Facebook
        let signWithFacebookButton = LoginButton.facebook()
        self.view.addSubview(signWithFacebookButton)
        signWithFacebookButton.snp.makeConstraints { (make) in
            make.top.equalTo(signWithEmailButton.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(47)
        }
        
        signWithFacebookButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                if let me = self {
                    me.facebookButton.setIsLoading(true)
                    me.output.signInWithFacebookPressed(from: me)
                }
            }).disposed(by: self.disposeBag)
        
        self.facebookButton = signWithFacebookButton
        
        // Apple
        let signWithAppleButton = LoginButton.apple()
        self.view.addSubview(signWithAppleButton)
        signWithAppleButton.snp.makeConstraints { (make) in
            make.top.equalTo(signWithFacebookButton.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(47)
        }
        
        signWithAppleButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                if let me = self {
                    me.appleButtton.setIsLoading(true, style: .gray)
                    me.output.signInWithApplePressed(from: me)
                }
            }).disposed(by: self.disposeBag)
        
        self.appleButtton = signWithAppleButton
        
        // "Or" label
        var orLabelOffset = 57.0
        UIDevice.onIphone5 {
            orLabelOffset = 24.0
        }
        
        let orLabel = UILabel()
        self.view.addSubview(orLabel)
        orLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signWithAppleButton.snp.bottom).offset(orLabelOffset)
            make.centerX.equalToSuperview()
        }
        
        orLabel.text = "or".localize()
        orLabel.textColor = .white
        
        // Create profile
        var createProfileButtonOffset = 38.0
        UIDevice.onIphone5 {
            createProfileButtonOffset = 18.0
        }
        let createProfileButton = UIButton()
        self.view.addSubview(createProfileButton)
        createProfileButton.snp.makeConstraints { (make) in
            make.top.equalTo(orLabel.snp.bottom).offset(createProfileButtonOffset)
            make.centerX.equalToSuperview()
        }
        
        let style = Style {
            $0.font = UIFont.boldSystemFont(ofSize: 20.0)
            $0.underline = (.single, "#EAAA47".color())
            $0.color = "#EAAA47".color()
        }
        
        UIDevice.onIphone5 {
            style.font = UIFont.boldSystemFont(ofSize: 15.0)
        }
        
        createProfileButton.setAttributedTitle("Create an account".localize().set(style: style), for: .normal)
        
        createProfileButton.addTarget(self.output,
                                      action: #selector(self.output.createUserPressed),
                                      for: .touchUpInside)
        
        // Logo
        /*let logoView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-112)
            make.height.equalTo(42)
            make.width.equalTo(179)
            make.centerX.equalToSuperview()
        }*/
        
        // Terms
        let terms = UITextView.temrs()
        self.view.addSubview(terms)
        terms.snp.makeConstraints { (make) in
            //make.top.equalTo(logoView.snp.bottom).offset(21)
            make.bottomMargin.equalToSuperview().offset(-28)
            make.width.equalTo(258)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: LoginSelectionViewInput
    func setupInitialState() {

    }
    
    func displayError(_ error: Error) {
        self.showError(error: error)
            .subscribe(onNext: { [weak self] _ in
                self?.facebookButton.setIsLoading(false)
                self?.appleButtton.setIsLoading(false)
            }).disposed(by: self.disposeBag)
    }
    
    func loginCancelled() {
        self.facebookButton.setIsLoading(false)
        self.appleButtton.setIsLoading(false)
    }


}



