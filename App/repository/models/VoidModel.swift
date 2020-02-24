//
//  File.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import RealmSwift

class VoidModel: Object, Codable {
    @objc dynamic var id: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }}
