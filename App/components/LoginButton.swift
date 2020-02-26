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
    
     var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
     var image: UIImage? = nil {
        didSet {
            self.imageView.image = self.image
        }
    }
    
     var text: String = "" {
        didSet {
            self.label.text = self.text
        }
    }
    
     var textColor: UIColor = .white {
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
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
        
      self.imageView.snp.makeConstraints { make in
        make.leading.equalTo(self.snp.leading).offset(15)
        make.top.equalToSuperview().offset(15)
        make.bottom.equalToSuperview().inset(15)
        make.width.equalTo(30)
        //make.centerY.equalToSuperview()
        }
        
        //self.imageV
        
        self.label = UILabel()
        self.addSubview(self.label)
        
       self.label.snp.makeConstraints { (make) in
          make.leading.equalTo(self.imageView.snp.trailing).offset(20)
          make.trailing.equalToSuperview().inset(10)
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
        button.text = "Login with Facebook".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = "#4267B2".color()
        button.textColor = UIColor.white
        button.image = UIImage(named: "facebook")

        return button
    }
    
    static func google() -> LoginButton {
        let button = LoginButton()
        button.text = "Login with Google".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = "#FFFFFF".color()
        button.textColor = UIColor.black
        let image = UIImage(named: "google")
        button.image = image
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }
    
}
