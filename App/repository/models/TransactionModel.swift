//
//  TransactionModel.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionModel: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var carId: Int = 0
    @objc dynamic var creditCardId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var amount: Int = 0 // In "øre" dkk, 1kr = 100, 10kr = 1000kr
    @objc dynamic var status: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case carId = "carpay_car_id"
        case creditCardId = "carpay_credit_card_id"
        case title = "title"
        case text = "text"
        case date = "created_at"
        case status = "status"
        case amount = "amount"
    }
}

