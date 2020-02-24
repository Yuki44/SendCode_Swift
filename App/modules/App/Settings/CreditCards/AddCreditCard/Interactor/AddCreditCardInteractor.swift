//
//  AddCreditCardAddCreditCardInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class AddCreditCardInteractor: AddCreditCardInteractorInput {

    var disposeBag = DisposeBag()
    weak var output: AddCreditCardInteractorOutput!
    var repository: CreditCardRepository!
    
    func createCard(_ card: CreditCardModel) {
        self.repository
            .createCreditCard(card)
            .subscribe(onNext: { (creditCard) in
                self.output.didCreatedCreditCard(creditCard)
            }, onError: { (error) in
                self.output.failedToCreateCreditCard(error: error)
            }).disposed(by: self.disposeBag)
    }
}
