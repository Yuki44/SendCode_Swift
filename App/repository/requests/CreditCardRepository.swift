//
//  CreditCardRepository.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import Foundation
import RxSwift

protocol CreditCardRepository {
    func getCreditCards() -> Observable<[CreditCardModel]>
    func createCreditCard(_ creditCard: CreditCardModel) -> Observable<CreditCardModel>
    func destroyCreditCard(_ creditCard: CreditCardModel) -> Observable<Bool>
}

extension DataRepository: CreditCardRepository {
    func getCreditCards() -> Observable<[CreditCardModel]> {
        let request = DataRepositoryRequest<CreditCardModel>(method: .get,
                                                             endpoint: "carpay/creditcards",
                                                             params: nil,
                                                             authorizationNeeded: true)
        
        return self.performRequest(request)
    }
    
    func createCreditCard(_ creditCard: CreditCardModel) -> Observable<CreditCardModel> {
        let params = ["creditcard": [
            "nickname": creditCard.name,
            "cardholder_name": creditCard.cardholderName,
            "card_expiration_date": creditCard.cardExpirationDate,
            "card_number": creditCard.cardNumber,
            "card_cvc": creditCard.cardCvc
            ]]
        
        let request = DataRepositoryRequest<CreditCardModel>(method: .post,
                                                      endpoint: "carpay/creditcards",
                                                      params: params,
                                                      authorizationNeeded: true)
        
        return self.performRequest(request).flatMap { (cards) -> Observable<CreditCardModel> in
            return Observable<CreditCardModel>.of(cards.first!)
        }
    }
    
    func destroyCreditCard(_ creditCard: CreditCardModel) -> Observable<Bool> {

        return Observable.create { (observable) -> Disposable in
            let request = DataRepositoryRequest<VoidModel>(method: .delete,
                                                           endpoint: "carpay/creditcards/\(creditCard.id)",
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

