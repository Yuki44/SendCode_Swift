//
//  FastTrackFastTrackViewInput.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

protocol FastTrackViewInput: class {

    /**
        @author Rasmus Styrk
        Setup initial state of the view
    */

    func setupInitialState()
    
    func displayFastTrack(_ fastTrack: FastTrackModel)
    func displayError(_ error: Error)
}
