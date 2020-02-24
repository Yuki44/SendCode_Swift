//
//  ServicesServicesInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class ServicesInteractor: ServicesInteractorInput {

    var disposeBag = DisposeBag()
    weak var output: ServicesInteractorOutput!
    var repository: ServicesRepository!

    func fetchServices() {
        self.repository.getAllServices().subscribe(onNext: { (services) in
            self.output.didFetchServices(services)
        }, onError: { (error) in
            self.output.failedToFetchServices(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func updateIsEnabled(_ isEnabled: Bool, for service: ServiceModel) {
        self.repository.updateIsEnabled(isEnabled, for: service).subscribe(onNext: { (service) in
            self.output.didUpdateService(service)
        }, onError: { (error) in
            self.output.failedToUpdateService(error: error)
        }).disposed(by: self.disposeBag)
    }
}
