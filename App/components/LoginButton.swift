//
//  LoginButton.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 Rasmus Styrk. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class LoginButton: UIControl {
    
    var activityIndicator: UIActivityIndicatorView!
    var imageView: UIImageView!
    var label: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    @IBInspectable var text: String = "" {
        didSet {
            self.label.text = self.text
        }
    }
    
    @IBInspectable var textColor: UIColor = .white {
        didSet {
            self.label.textColor = self.textColor
            self.imageView.tintColor = self.textColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        self.imageView = UIImageView(image: nil)
        self.imageView.tintColor = self.textColor
        self.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            
            //make.width.height.equalTo(20)
        }
        
        //self.imageV
        
        self.label = UILabel()
        self.addSubview(self.label)
        
        self.label.snp.makeConstraints { (make) in
            make.left.equalTo(43)
            make.right.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.activityIndicator.isHidden = true
    }
    
    func setIsLoading(_ loading: Bool, style: UIActivityIndicatorView.Style = .white) {
        self.isEnabled = !loading
        self.activityIndicator.isHidden = !loading
        self.label.isHidden = loading
        self.activityIndicator.style = style
        if loading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension LoginButton {
    static func facebook() -> LoginButton {
        let button = LoginButton()
        button.text = "Log ind med Facebook".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = "#4267B2".color()
        button.textColor = UIColor.white
        button.image = UIImage(named: "facebook")
        return button
    }
    
    static func email() -> LoginButton {
        let button = LoginButton()
        button.text = "Log ind med E-mail".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = "#EAAA47".color()
        button.textColor = UIColor.white
        button.image = UIImage(named: "email")
        return button
    }
    
    static func apple() -> LoginButton {
        let button = LoginButton()
        button.text = "Log ind med Apple".localize()
        button.cornerRadius = 10.0
        button.image = UIImage(named: "apple")
        button.backgroundColor = .white
        button.textColor = .black
        return button
    }
}
