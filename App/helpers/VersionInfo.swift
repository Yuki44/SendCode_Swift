//
//  VersionInfo.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

extension Bundle {
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        let bundleId = self.bundleIdentifier!
        #if DEBUG
        return "\(bundleId)/\(version) (\(build)) [debug]"
        #else
        return "\(bundleId)/\(version) (\(build)) [release]"
        #endif
    }
}
