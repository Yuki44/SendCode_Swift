//
//  PushTokenRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 07/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol PushTokenRepository {
    func registerToken(_ token: String)
}

extension DataRepository: PushTokenRepository {
    func registerToken(_ token: String) {
        let params = ["push_token": [
            "platform": "ios",
            "token": token
            ]]
        
        let request = DataRepositoryRequest<VoidModel>(method: .post,
                                                            endpoint: "push/register",
                                                            params: params,
                                                            authorizationNeeded: true)
        
        
        self.performRequest(request).subscribe().disposed(by: self.disposeBag)
    }
}
