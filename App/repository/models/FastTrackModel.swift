//
//  FastTrackModel.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RealmSwift

class FastTrackModel: Object, Codable  {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var autoCheckout: Bool = false
    @objc dynamic var autoReplay: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case autoCheckout = "auto_checkout"
        case autoReplay = "auto_replay"
    }
}
