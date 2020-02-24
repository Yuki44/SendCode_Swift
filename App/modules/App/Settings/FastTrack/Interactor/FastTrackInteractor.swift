//
//  FastTrackFastTrackInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import RxSwift

class FastTrackInteractor: FastTrackInteractorInput {

    var disposeBag = DisposeBag()
    weak var output: FastTrackInteractorOutput!
    var repository: FastTrackRepository!
    
    func fetchFastTrack() {
        self.repository.getFastTrackSettings().subscribe(onNext: { (fastTrack) in
            self.output.fastTrackFetched(track: fastTrack)
        }, onError: { (error) in
            self.output.failedToFetchFastTrack(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func updateFastTrack(track: FastTrackModel) {
        self.repository.updateFastTrack(track).subscribe(onNext: { (track) in
            //?
        }, onError: { (error) in
            self.output.failedToUpdateFastTrack(error: error)
        }).disposed(by: self.disposeBag)
    }
}
