//
//  TermsTextView.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import SwiftRichString

extension UITextView {
    static func temrs() -> UITextView {
        let terms = UITextView()
        
        terms.isEditable = false
        terms.showsVerticalScrollIndicator = false
        terms.showsHorizontalScrollIndicator = false
        terms.textAlignment = .center
        terms.backgroundColor = .clear
       // terms.tintColor = .white
        
        let normal = Style {
            $0.color = UIColor.lightGray
            $0.alignment = .center
            $0.minimumLineHeight = 18.0
        }
        
        let link = Style {
            $0.color = UIColor.systemBlue
            $0.underline = (.single, UIColor.systemBlue)
            $0.linkURL = URLRepresentable.tagAttribute("href")
        }
        
        let group = StyleGroup.init(base: normal, ["a" : link])
        
        let bodyHTML = "By continuing, you agree to our <a href=\"http://www.houseofcode.io\"> Terms of Use </a> and our <a href=\"http://www.houseofcode.io\"> Privacy Policy </a>.".localize()

        terms.attributedText = bodyHTML.set(style: group)
        
        return terms
    }
}
