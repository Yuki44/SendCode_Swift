//
//  CarEditFormCarEditFormInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class CarEditFormInteractor: CarEditFormInteractorInput {
    var disposeBag = DisposeBag()
    var repostiroy: (CarRepository & CreditCardRepository)!
    weak var output: CarEditFormInteractorOutput!
    
    func fetchCreditCards() {
        self.repostiroy.getCreditCards().subscribe(onNext: { (cards) in
            self.output.didFetchCreditCards(cards: cards)
        }, onError: { (error) in
            self.output.failedToFetchCreditCards(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func createCar(_ carModel: CarModel) {
        self.repostiroy.createCar(carModel)
            .subscribe(onNext: { (car) in
                self.output.sucessfullySavedCar(car)
            }, onError: { (error) in
                self.output.failedToSaveCar(error: error)
            }).disposed(by: self.disposeBag)
    }
    
    func updateCar(_ carModel: CarModel) {
        self.repostiroy.updateCar(carModel)
            .subscribe(onNext: { (car) in
                self.output.sucessfullySavedCar(car)
            }, onError: { (error) in
                self.output.failedToSaveCar(error: error)
            }).disposed(by: self.disposeBag)
    }
}
