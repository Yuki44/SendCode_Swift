//
//  FastTrackFastTrackViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class FastTrackViewController: FormViewController, FastTrackViewInput {

    var disposeBag = DisposeBag()
    var output: FastTrackViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fast Track".localize()
        self.view.backgroundColor = Theme.backgroundColor
        self.tableView!.backgroundColor = .clear
        
        output.viewIsReady()
    }

    func displayFastTrack(_ fastTrack: FastTrackModel) {
        form.removeAll()
        
        form +++ Section(header: "Automatisk checkout".localize(), footer: "Ved aktivering godkender systemet automatisk dine køb uden at behøver have telefonen op af lommen".localize())
            <<< SwitchRow("autoCheckout"){
                $0.title = "Aktiveret".localize()
                $0.value = fastTrack.autoCheckout
                $0.onChange { (row) in
                    let model = FastTrackModel()
                    model.id = fastTrack.id
                    model.autoCheckout = row.value!
                    model.autoReplay = fastTrack.autoReplay
                    self.output.updateFastTrack(track: model)
                }
        }
        
        form +++ Section(header: "Genbestil".localize(), footer: "Ved aktivering vil du blive spurgt om du vil genbestille sidste bestilling, uden at skulle snakke med en ekspedient".localize())
            <<< SwitchRow("autoReplay"){
                $0.title = "Aktiveret".localize()
                $0.value = fastTrack.autoReplay
                $0.onChange { (row) in
                    let model = FastTrackModel()
                    model.id = fastTrack.id
                    model.autoCheckout = fastTrack.autoCheckout
                    model.autoReplay = row.value!
                    self.output.updateFastTrack(track: model)
                }
        }
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }
    
    override func insertAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        return .none
    }
    
    // MARK: FastTrackViewInput
    func setupInitialState() {
    }
}
