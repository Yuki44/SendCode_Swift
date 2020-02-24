//
//  ServicesServicesViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class ServicesViewController: FormViewController, ServicesViewInput {

    var disposeBag = DisposeBag()
    var output: ServicesViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Services".localize()
        self.tableView!.backgroundColor = .clear
        
        output.viewIsReady()
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }
    
    func displayServices(_ services: [ServiceModel]) {
        form.removeAll()
        form +++ Section(header: "Vælg services".localize(), footer: "Aktiver eller deaktiver services hvor du ønsker at kunne benytte carpay".localize())
          
        for service in services {
            form.last! <<< SwitchRow("service\(service.id)") {
                $0.title = service.title
                $0.value = service.isEnabled
                $0.onChange { (row) in
                    self.output.updateIsEnabled(row.value!, for: service)
                }
            }
        }
    }

    override func insertAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        return .none
    }
    
    // MARK: ServicesViewInput
    func setupInitialState() {
    }
}
