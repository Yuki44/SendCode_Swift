//
//  ServiceModel.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceModel: Object, Codable  {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var isEnabled: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case isEnabled = "is_enabled"
    }
}
