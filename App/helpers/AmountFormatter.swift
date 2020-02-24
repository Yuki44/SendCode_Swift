//
//  AmountFormatter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation

extension Int {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "da_DK")
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: Double(self)/100.0)) ?? "-"
    }
}
