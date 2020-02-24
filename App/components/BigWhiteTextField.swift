//
//  BigWhiteInputField.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

class BigWhiteTextField: UITextField {
    
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
        self.layer.cornerRadius = 10.0
        self.backgroundColor = .white
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding: CGFloat = 15.0
        return CGRect(x: bounds.origin.x + padding,
                      y: bounds.origin.y,
                      width: bounds.width - padding,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding: CGFloat = 15.0
        return CGRect(x: bounds.origin.x + padding,
                      y: bounds.origin.y,
                      width: bounds.width - padding,
                      height: bounds.height)
    }
}
