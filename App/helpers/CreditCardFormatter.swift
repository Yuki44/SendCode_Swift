//
//  CreditCardFormatter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import UIKit

class CreditCardFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
    
        guard let stringValue = obj as? String else {
            return nil
        }
        
        var formattedString = String()
        let normalizedString = stringValue.replacingOccurrences(of: " ", with: "")
        
        var idx = 0
        var character: Character
        while idx < normalizedString.count {
            let index = normalizedString.index(normalizedString.startIndex, offsetBy: idx)
            character = normalizedString[index]
            
            if idx != 0 && idx % 4 == 0 {
                formattedString.append(" ")
            }
            
            formattedString.append(character)
            idx += 1
        }
        
        return formattedString
    }
    
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        return true
    }
}
