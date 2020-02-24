//
//  DataRepository.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 19/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import RealmSwift

/// Data Repository
///
/// The main data repository that handles fetching and storing of the API
///
/// All requests will be store in a local realm database and if there is no internet the stored data
/// will be returned. This enables the app to work offline.
///
/// Posting in offlne mode will return a `notSupportedWhenOffline` error.
///
/// To make requests you need to initiate a `DataRepositoryRequest` object and configure it. Then
/// the repository takes care of the rest. All requests should be added to the `DataRepository` class as
/// extentions using protocols.
class DataRepository {
    
    /// Some standard errors
    enum Error: Swift.Error {
        case notSupportedWhenOffline
        case cacheCorrupted
        case authorizationMissing
    }
    
    /// Rx Dispose bag
    var disposeBag = DisposeBag()
    
    /// The repository base URL
    private var baseUrl: String
    
    /// The repository api key (used in every request)
    private var apiKey: String

    /// Reachabitlity class to listen for network changes
    private var network: NetworkReachabilityManager
    
    /// If we are connected to network or not
    var isConnected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    
    /// The user to use when doing authorized requests
    var authorizationEntity: DataRepositoryAuthorizationEntity?
    
    /// The UUID of the device
    var uuid: String {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "uuid") {
            return uuid
        }
        
        // Generate uuid
        let uuid = UUID()
        defaults.set(uuid.uuidString, forKey: "uuid")
        defaults.synchronize()
        
        return uuid.uuidString
    }
    
    /// Init with base URL
    /// Sets up network listener
    init(baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        
        log.info("Reposistory setup with url: \(baseUrl)")
        
        self.network = NetworkReachabilityManager(host: "www.apple.com")!
        self.isConnected.accept(self.network.status != .notReachable && self.network.status != .unknown)
        self.network.startListening { [unowned self] (status) in
            log.info("[network] Status changed: \(status)")
            self.isConnected.accept(status != .notReachable && status != .unknown)
        }
    }
    
    /// Stops network listener
    deinit {
        self.network.stopListening()
    }
    
    /// Perform request
    ///
    /// Performs a network request using a `DataRepositoryRequest` struct. When request completes the result will be
    /// stored in the database for later use.
    ///
    /// Request type must conform to both `Object` (realm) and `Codable`.  This enables automatic saving to database and json decoding.
    ///
    /// On any error the request is failed. If no internet then the stored data will be returned (only for .get requests).
    func performRequest<T>(_ request: DataRepositoryRequest<T>) -> Observable<[T]> where T: Object & Codable {
        return Observable.create { (observable) -> Disposable in
   
            log.info("Runnnig request: \(request)")
            
            if !self.isConnected.value {
                if request.method != .get {
                    log.error("Request: [realm] \(request) failed with error: \(Error.notSupportedWhenOffline)")
                    observable.onError(Error.notSupportedWhenOffline)
                } else {
                    do {
                        let realm = try Realm()
                        var objects = [T]()
                        
                        var query = realm.objects(T.self)
                        
                        if let predicate = request.cachePredicate {
                            query = query.filter(predicate)
                        }
                        
                        query.forEach { (object) in
                            objects.append(object)
                        }
                        
                        log.info("Request: [realm]  \(request) loaded objects: \(objects)")
                        observable.onNext(objects)
                        observable.onCompleted()
                    } catch let error {
                        log.error("Request: [realm] \(request) failed with error: \(error)")
                        observable.onError(error)
                    }
                }
            } else {
                self.buildRequest(request: request)
                    .validate(statusCode: 200..<300)
                    .response { (alamoResponse) in
                        switch(alamoResponse.result)
                        {
                        case .failure(let error):
                            if let data = alamoResponse.data {
                                if let decodedObject = try? JSONDecoder().decode(ApiError.self, from: data) {
                                    log.error("Request: [online] \(request) failed with error: \(decodedObject)")
                                    observable.onError(decodedObject)
                                    return
                                }
                            }
                            
                            log.error("Request: [online] \(request) failed with error: \(error)")
                            observable.onError(error)
                            break
                        case .success(let value):
                            do {
                                log.info("Request: [online] \(request) got value: \(String(data: value!, encoding: .utf8))")
                                
                                let realm = try Realm()
                                var objects = [T]()
                                
                                let decoder = JSONDecoder()
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                                decoder.dateDecodingStrategy = .formatted(formatter)
                                
                                if let decodedObjects = try? decoder.decode([T].self, from: value!) {
                                    objects = decodedObjects
                                }
                                
                                if let decodedObject = try? decoder.decode(T.self, from: value!) {
                                    objects = [decodedObject]
                                }
                                
                                try realm.write {
                                    realm.add(objects, update: .modified)
                                }
                                
                                log.info("Request: [online]  \(request) loaded objects: \(objects) ")
                                
                                observable.onNext(objects)
                                observable.onCompleted()
                            } catch let error {
                                log.error("Request: [online] \(request) failed with error: \(error)")
                                observable.onError(error)
                            }
                            
                            break
                        }
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func buildRequest<T>(request: DataRepositoryRequest<T>) -> DataRequest where T: Object & Codable {
        
        let url = "\(self.baseUrl)/\(self.apiKey)/\(request.endpoint)"
        
        var headers = HTTPHeaders()
        
        if request.authorizationNeeded {
            if let entity = self.authorizationEntity {
                headers["Authorization"] = entity.token
            }
        }
        
        if let multipart = request.multipartData {
            return AF.upload(multipartFormData: multipart,
                             to: url,
                             usingThreshold: MultipartFormData.encodingMemoryThreshold,
                             method: request.method,
                             headers: headers)
        } else {
            return  AF.request(url,
                               method: request.method,
                               parameters: request.params,
                               encoding: URLEncoding.default,
                               headers: headers)
        }
    }
}
