//
//  FastTrackRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol FastTrackRepository {
    func getFastTrackSettings() -> Observable<FastTrackModel>
    func updateFastTrack(_ fastTrack: FastTrackModel) -> Observable<FastTrackModel>
}

extension DataRepository: FastTrackRepository {
    func getFastTrackSettings() -> Observable<FastTrackModel> {
        let request = DataRepositoryRequest<FastTrackModel>(method: .get,
                                                             endpoint: "carpay/fasttrack",
                                                             params: nil,
                                                             authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (tracks) -> Observable<FastTrackModel> in
            return Observable<FastTrackModel>.of(tracks.first!)
        }
    }
    
    func updateFastTrack(_ fastTrack: FastTrackModel) -> Observable<FastTrackModel> {
        
        let params = ["fasttrack": [
            "auto_checkout": fastTrack.autoCheckout,
            "auto_replay": fastTrack.autoReplay
            ]]
        
        let request = DataRepositoryRequest<FastTrackModel>(method: .patch,
                                                            endpoint: "carpay/fasttrack/\(fastTrack.id)",
                                                      params: params,
                                                      authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (tracks) -> Observable<FastTrackModel> in
            return Observable<FastTrackModel>.of(tracks.first!)
        }
    }
}
