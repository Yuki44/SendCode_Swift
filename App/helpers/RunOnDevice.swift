//
//  FloatingDevicePoint.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit

/// An helper extension for making it easier to adjust stuff depending on device
///
/// For example sometimes you want to move a view tighter together in a small screen because the screen real estate is
/// significantly smaller on an iPhone 5s.
///
/// Example of use:
///
///
///  var createProfileButtonOffset = 38.0
///  UIDevice.onIphone5 {
///      createProfileButtonOffset = 18.0
///  }
///
/// Then the button offset is changed only on iPhone5, 5s and SE
extension UIDevice {
    
    /// Device models we currently support
    enum DeviceTypeModel {
        case iphoneX // X and X Pro
        case iphone8Plus // And 6plus, 7plus
        case iphone8 // And 6, 6s, 7, 7s
        case iphoneSE //SE is the like iphone 5 and iphone 5s
        case iphone4s
    }
    
    /// Helper to run stuff on a specfic device
    private func onDeviceType(_ completion: (DeviceTypeModel) -> Void) {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                completion(.iphoneX)
            case 1920:
                completion(.iphone8Plus)
            case 1334:
                completion(.iphone8)
            case 1136:
                completion(.iphoneSE)
            default:
                completion(.iphone4s)
            }
        }
    }
    
    /// Executes code on a signle device
    static func onDeviceType(_ type: DeviceTypeModel, completion: (() -> Void)) {
        UIDevice.current.onDeviceType { (model) in
            if (model == type) {
                completion()
            }
        }
    }
    
    /// Run only on iphone5, 5s, se
    static func onIphone5(_ completion: (() -> Void)) {
        return onDeviceType(.iphoneSE, completion: completion)
    }
    
    /// Run only on iPhone8, 8s,  7, 7s, 6, 6s
    static func onIphone8(_ completion: (() -> Void)) {
        return onDeviceType(.iphone8, completion: completion)
    }
    
    /// Run only on iPhone8plus, 6plus, 7plus
    static func onIphone8Plus(_ completion: (() -> Void)) {
        return onDeviceType(.iphone8Plus, completion: completion)
    }
    
    /// Run on X modeles
    static func onIphoneX(_ completion: (() -> Void)) {
        return onDeviceType(.iphoneX, completion: completion)
    }
}
