//
//  DataRepositoryRequest.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 19/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

/// Data Repository Request
///
/// T must conformt to both `Object` and `Codable` for caching and data decoding purposes.
struct DataRepositoryRequest<T: Object & Codable> {
    /// The HTTP method to use. The reuqest will be executed  using this method in Alamofire
    var method: HTTPMethod = .get
    
    /// Endpoint to call. Only add path, as in `/user` and not the full url
    var endpoint: String
    
    /// Parameters to be send as json
    var params: [String: Any]?
    
    /// Cache predicate is used for when fetching data in the cache
    ///
    /// This can be helpfull if you have two requets that returns the same kind of model T, where all model T's are stored
    /// in the same realm table, but you only want to get a subset from the table.
    ///
    /// Consider these two requets
    ///
    /// GET /groups/1
    /// GET /groups/2
    ///
    /// Without a cache predicate, the cache would return both groups when offline but you are actually only interrested in one.
    ///
    /// Cache predicate is given directly to realm so it supports whatever realm does, so "id = 1"
    /// would return group 1, or "category_id =  '1'" would return all groups with category 1 (the model needs to have the field defined).
    /// 
    /// More advanced predicate can also be used, for example: "color = 'tan' AND name BEGINSWITH 'B'"
    ///
    /// Read more: https://realm.io/docs/swift/latest/#filtering
    var cachePredicate: String?
    
    /// If the request requires user authorization
    var authorizationNeeded: Bool = false
    
    /// When data is provided we upload instead
    var multipartData: Alamofire.MultipartFormData?
}

protocol DataRepositoryAuthorizationEntity {
    var token: String { get set }
}
