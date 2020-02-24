//
//  UserModel.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 Rasmus Styrk. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object, Codable, DataRepositoryAuthorizationEntity {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatarUrl: String?
    @objc dynamic var token: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case token = "token"
        case avatarUrl = "avatarUrl"
    }
}
