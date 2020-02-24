//
//  FastTrackFastTrackInteractorOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import Foundation

protocol FastTrackInteractorOutput: class {
    func fastTrackFetched(track: FastTrackModel)
    func failedToFetchFastTrack(error: Error)
    func failedToUpdateFastTrack(error: Error)
}
