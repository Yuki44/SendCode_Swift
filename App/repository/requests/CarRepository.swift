//
//  CarRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol CarRepository {
    func getCars() -> Observable<[CarModel]>
    func getCar(id: Int) -> Observable<CarModel>
    func createCar(_ car: CarModel) -> Observable<CarModel>
    func updateCar(_ car: CarModel) -> Observable<CarModel>
    func destroyCar(_ car: CarModel) -> Observable<Bool>
}

extension DataRepository: CarRepository {
    func getCars() -> Observable<[CarModel]> {
        let request = DataRepositoryRequest<CarModel>(method: .get,
                                                              endpoint: "carpay/cars",
                                                              params: nil,
                                                              authorizationNeeded: true)
        
        return self.performRequest(request)
    }
    
    func getCar(id: Int) -> Observable<CarModel> {
        let request = DataRepositoryRequest<CarModel>(method: .get,
                                                      endpoint: "carpay/cars/\(id)",
            params: nil,
            authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (cars) -> Observable<CarModel> in
            return Observable<CarModel>.of(cars.first!)
        }
    }
    
    func createCar(_ car: CarModel) -> Observable<CarModel> {
        
        let params = ["car": [
            "nickname": car.name,
            "platenumber": car.plateNumber,
            "carpay_credit_card_id": car.creditCardId
            ]]
        
        let request = DataRepositoryRequest<CarModel>(method: .post,
                                                      endpoint: "carpay/cars",
                                                      params: params,
                                                      authorizationNeeded: true)
    
        return self.performRequest(request).flatMap { (cars) -> Observable<CarModel> in
            return Observable<CarModel>.of(cars.first!)
        }
    }
    
    func updateCar(_ car: CarModel) -> Observable<CarModel> {
        
        let params = ["car": [
            "nickname": car.name,
            "platenumber": car.plateNumber,
            "carpay_credit_card_id": car.creditCardId
            ]]
        
        
        let request = DataRepositoryRequest<CarModel>(method: .patch,
                                                      endpoint: "carpay/cars/\(car.id)",
                                                      params: params,
                                                      authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (cars) -> Observable<CarModel> in
            return Observable<CarModel>.of(cars.first!)
        }
    }
    
    func destroyCar(_ car: CarModel) -> Observable<Bool> {
        
        return Observable.create { (observable) -> Disposable in
            let request = DataRepositoryRequest<VoidModel>(method: .delete,
                                                           endpoint: "carpay/cars/\(car.id)",
                params: nil,
                authorizationNeeded: true)
            
            self.performRequest(request).subscribe(onNext: { (voids) in
                observable.onNext(true)
                observable.onCompleted()
            }, onError: { (error) in
                observable.onError(error)
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
