//
//  ServicesRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol ServicesRepository {
    func getAllServices() -> Observable<[ServiceModel]>
    func updateIsEnabled(_ isEnabled: Bool, for service: ServiceModel) -> Observable<ServiceModel>
}

extension DataRepository: ServicesRepository {
    func getAllServices() -> Observable<[ServiceModel]> {
        let request = DataRepositoryRequest<ServiceModel>(method: .get,
                                                            endpoint: "carpay/services",
                                                            params: nil,
                                                            authorizationNeeded: true)
        
        return self.performRequest(request)
    }
    
    func updateIsEnabled(_ isEnabled: Bool, for service: ServiceModel) -> Observable<ServiceModel> {
        
        let params = ["service": [
            "is_enabled": isEnabled
            ]]
        
        let request = DataRepositoryRequest<ServiceModel>(method: .patch,
                                                      endpoint: "carpay/services/\(service.id)",
            params: params,
            authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (cars) -> Observable<ServiceModel> in
            return Observable<ServiceModel>.of(cars.first!)
        }
    }
}
