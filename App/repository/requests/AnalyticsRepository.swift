//
//  AnalyticsRepository.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

protocol AnalyticsRepository {
    //func logEvent(event: AnalyticLogEvent)
    func logEvent(event: String)
    func logEvent(event: String, data: [String: Any]?)
}

extension DataRepository: AnalyticsRepository {
    
   /* enum AnalyticLogEvent: String {
        case AppOpen = "APP_OPEN"
    }*/
    
    func logEvent(event: String) {
        self.logEvent(event: event, data: nil)
    }
    
    func logEvent(event: String, data: [String : Any]?) {
        
        var params: [String: Any] = [:]
        params["event"] = event
        params["platform"] = "ios"
        params["device_id"] = self.uuid
        
        if let dataParams = data {
            params["data"] = dataParams
        }
        
        let request = DataRepositoryRequest<VoidModel>(method: .post,
                                                       endpoint: "analytics/log",
                                                       params: ["analytic": params])
        
        self.performRequest(request).subscribe().disposed(by: self.disposeBag)
    }
}
