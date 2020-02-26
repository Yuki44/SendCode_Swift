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
    
    var output: LoginSelectionViewOutput?
    var disposeBag = DisposeBag()
    var facebookButton: LoginButton?
    var googleButton: LoginButton?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        
        // Background
        //        let background = UIImageView(image: UIImage(named: "login_bg"))
        //         background.contentMode = .scaleAspectFill
        //         self.view.addSubview(background)
        //         background.snp.makeConstraints { (make) in
        //         make.edges.equalToSuperview()
        //         }
        
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
            //make.leading.equalTo(self.view.snp.leading).offset(27)
            make.centerX.equalToSuperview()
            //make.leading.equalTo().offset(27)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(offset)
        }
        //headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27)
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textColor = UIColor.darkGray
        headerLabel.text = "Welcome to Send Code!".localize()
        
        // Terms
        let terms = UITextView.temrs()
        self.view.addSubview(terms)
        terms.snp.makeConstraints { (make) in
            // make.top.equalTo(logoView.snp.bottom).offset(21)
            make.bottomMargin.equalToSuperview().offset(-28)
            make.width.equalTo(258)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
        }
        
        // Facebook
        let signWithFacebookButton = LoginButton.facebook()
        self.view.addSubview(signWithFacebookButton)
        signWithFacebookButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(terms.snp.top).offset(-25)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(60)
        }
        
        signWithFacebookButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                if let me = self {
                    
                    if let facebookButton = me.facebookButton {
                        facebookButton.setIsLoading(true)
                    }
                    
                    if let output = me.output {
                        output.signInWithFacebookPressed(from: me)
                    }
                    
                }
            }).disposed(by: self.disposeBag)
        
        self.facebookButton = signWithFacebookButton
        
        // Google
        let signWithGoogleButton = LoginButton.google()
        self.view.addSubview(signWithGoogleButton)
        signWithGoogleButton.snp.makeConstraints { (make) in
            make.top.equalTo(signWithFacebookButton.snp.top).offset(-75)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(60)
        }
        
        signWithGoogleButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                if let me = self {
                    if let googleButton = me.googleButton {
                        googleButton.setIsLoading(true)
                    }
                    if let output = me.output {
                        output.signInWithGooglePressed(from: me)
                    }
                }
            }).disposed(by: self.disposeBag)
        
        self.googleButton = signWithGoogleButton
        // "Or" label
        //        var orLabelOffset = 57.0
        //        UIDevice.onIphone5 {
        //            orLabelOffset = 24.0
        //        }
        //
        //        let orLabel = UILabel()
        //        self.view.addSubview(orLabel)
        //        orLabel.snp.makeConstraints { (make) in
        //            if let facebookButton = self.facebookButton {
        //                make.top.equalTo(facebookButton.snp.bottom).offset(orLabelOffset)
        //            }
        //
        
        //            make.centerX.equalToSuperview()
        
        //        }
        //
        //        orLabel.text = "or".localize()
        //        orLabel.textColor = .black
        //
        // Create profile
        //        var createProfileButtonOffset = 38.0
        //        UIDevice.onIphone5 {
        //            createProfileButtonOffset = 18.0
        //        }
        //        let createProfileButton = UIButton()
        //        self.view.addSubview(createProfileButton)
        //        createProfileButton.snp.makeConstraints { (make) in
        //            make.top.equalTo(orLabel.snp.bottom).offset(createProfileButtonOffset)
        //            make.centerX.equalToSuperview()
        //        }
        //
        //        let style = Style {
        //            $0.font = UIFont.boldSystemFont(ofSize: 20.0)
        //            $0.underline = (.single, "#EAAA47".color())
        //            $0.color = "#EAAA47".color()
        //        }
        //
        //        UIDevice.onIphone5 {
        //            style.font = UIFont.boldSystemFont(ofSize: 15.0)
        //        }
        //
        //        createProfileButton.setAttributedTitle("Create an account".localize().set(style: style), for: .normal)
        //
        //        if let output = self.output {
        //            createProfileButton.addTarget(output,
        //                                          action: #selector(output.createUserPressed),
        //                                          for: .touchUpInside)
        //        }
        
        
        // Logo
        let logoView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            
            make.top.equalTo(headerLabel.snp.bottom).offset(45)
            make.height.equalTo(180)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    // MARK: LoginSelectionViewInput
    func setupInitialState() {
        
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error)
            .subscribe(onNext: { [weak self] _ in
                self?.facebookButton?.setIsLoading(false)
            }).disposed(by: self.disposeBag)
    }
    
    func loginCancelled() {
        self.facebookButton?.setIsLoading(false)
    }
    
    
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VCPreview: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        VCContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct VCContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<VCPreview.VCContainerView>) -> UIViewController {
            let viewController = LoginSelectionViewController()
            
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VCPreview.VCContainerView>) {}
        
        typealias UIViewControllerType = UIViewController
    }
    
}
#endif


