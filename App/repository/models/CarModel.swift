//
//  CarModel.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RealmSwift

class CarModel: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var creditCardId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var plateNumber: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case creditCardId = "carpay_credit_card_id"
        case name = "nickname"
        case plateNumber = "platenumber"
    }
}
