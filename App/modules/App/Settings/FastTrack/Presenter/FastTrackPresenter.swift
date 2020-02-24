//
//  FastTrackFastTrackPresenter.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

class FastTrackPresenter: FastTrackModuleInput, FastTrackViewOutput, FastTrackInteractorOutput {

    weak var view: FastTrackViewInput!
    var interactor: FastTrackInteractorInput!
    var router: FastTrackRouterInput!

    func viewIsReady() {
        self.interactor.fetchFastTrack()
        self.view.setupInitialState()
    }
    
    func fastTrackFetched(track: FastTrackModel) {
        self.view.displayFastTrack(track)
    }
    
    func failedToFetchFastTrack(error: Error) {
        self.view.displayError(error)
    }
    
    func updateFastTrack(track: FastTrackModel) {
        self.interactor.updateFastTrack(track: track)
    }
    
    func failedToUpdateFastTrack(error: Error) {
        self.view.displayError(error)
    }
}
