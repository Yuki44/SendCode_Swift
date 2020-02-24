//
//  DateFormatting.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

extension Date {
    func formatAsString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "da_DK")
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func formatAsCreditCardExpiration() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "da_DK")
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    static func CreditCardFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "da_DK")
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
}
