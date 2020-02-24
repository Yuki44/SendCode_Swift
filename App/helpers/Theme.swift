//
//  Theme.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

struct Theme {
    static var textHeaderColor = "#442104".color()
    static var primaryTextColor = "#442104".color()
    static var secondaryTextColor = "#693306".color()
    static var backgroundColor = "#F2F0E9".color()
}

extension Theme {
    static func applyAppearance() {
        
        UINavigationBar
            .appearance()
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.textHeaderColor]
        
        UINavigationBar
            .appearance()
            .largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  Theme.textHeaderColor]

        UINavigationBar
            .appearance()
            .tintColor = Theme.textHeaderColor
    }
}
