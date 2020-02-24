//
//  Localization.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 23/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

extension String {
    /// Localiation cache - should hold all the localized strings
    ///
    /// ["Hej verden": "Hello World"]
    ///
    /// This cache needs to be set from the outside, for example in the AppCoordinator when localizations is ready
    static var localizationCache = [String: String]()
    
    /// Returns a localized string if present otherwise self
    ///
    ///
    func localize() -> String {
        return String.localizationCache[self] ?? self
    }
}
