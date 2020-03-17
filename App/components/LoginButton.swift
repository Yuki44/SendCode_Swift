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
          make.centerY.equalToSuperview()
         make.centerX.equalToSuperview()
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
    static func login() -> LoginButton {
        let button = LoginButton()
        button.text = "Login".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = UIColor(red:0.87, green:0.53, blue:0.13, alpha:1)
        button.textColor = UIColor.white
        button.label.textAlignment = .center
      button.label.font = UIFont.boldSystemFont(ofSize: 20)
        button.label.adjustsFontForContentSizeCategory = true
        return button
    }
    
    static func signup() -> LoginButton {
        let button = LoginButton()
        button.text = "Opret ny virksomhedsprofil".localize()
        button.cornerRadius = 10.0
        button.backgroundColor = UIColor(red:0.27, green:0.47, blue:0.54, alpha:1)
      button.label.font = UIFont.preferredFont(forTextStyle: .body)
               button.label.adjustsFontForContentSizeCategory = true
        button.textColor = UIColor.white
        return button
    }
    
}
