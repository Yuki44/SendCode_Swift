//
//  CarsCarsInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class CarsInteractor: CarsInteractorInput {

    var disposeBag = DisposeBag()
    var repository: CarRepository!
    weak var output: CarsInteractorOutput!
    
    func fetchCars() {
        self.repository.getCars().subscribe(onNext: { (cars) in
            self.output.didFetchCars(cars)
        }, onError: { (error) in
            self.output.failedToFetchCars(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func destroyCar(carModel: CarModel) {
        self.repository.destroyCar(carModel).subscribe(onNext: { (success) in
            self.output.didDestroyCar(carModel)
        }, onError: { (error) in
            self.output.failedToDestroyCar(error: error)
        }).disposed(by: self.disposeBag)
    }
}
