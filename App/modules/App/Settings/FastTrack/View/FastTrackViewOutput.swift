//
//  FastTrackFastTrackViewOutput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol FastTrackViewOutput {

    /**
        @author Rasmus Styrk
        Notify presenter that view is ready
    */

    func viewIsReady()
    func updateFastTrack(track: FastTrackModel)
}
