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
        terms.tintColor = .white
        
        let normal = Style {
            $0.color = UIColor.white
            $0.alignment = .center
            $0.minimumLineHeight = 18.0
        }
        
        let link = Style {
            $0.color = UIColor.white
            $0.underline = (.single, UIColor.white)
            $0.linkURL = URLRepresentable.tagAttribute("href")
        }
        
        let group = StyleGroup.init(base: normal, ["a" : link])
        
        let bodyHTML = "Ved at forsætte accepterer du vores <a href=\"http://www.houseofcode.io\">Betingelser fo rbrug</a> samt vores <a href=\"http://www.houseofcode.io\">Privatlivs politik</a>.".localize()
        
        terms.attributedText = bodyHTML.set(style: group)
        
        return terms
    }
}
