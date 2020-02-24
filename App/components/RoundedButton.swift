//
//  RoundedButton.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import SnapKit

class RoundedButton: UIButton {
    
    var activityView: UIActivityIndicatorView?
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 22.0
        
        self.activityView = UIActivityIndicatorView(style: .white)
        self.addSubview(self.activityView!)
        self.activityView!.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.activityView?.isHidden = true
    }
    
    func setEnabled(_ enabled: Bool) {
        if enabled {
            self.isEnabled = true
            self.backgroundColor = "#EAAA47".color()
            self.setTitleColor("#593600".color(), for: .normal)
        } else {
            self.isEnabled = false
            self.backgroundColor = "#F0EEEC".color().withAlphaComponent(0.4)
            self.setTitleColor("#98A1A1".color(), for: .normal)
        }
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            self.setTitleColor(.clear, for: .normal)
            self.isEnabled = false
            self.activityView?.isHidden = false
            self.activityView?.startAnimating()
        } else {
            self.setEnabled(true)
            self.activityView?.isHidden = true
        }
    }
}
