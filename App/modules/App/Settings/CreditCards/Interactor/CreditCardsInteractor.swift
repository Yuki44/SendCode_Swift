//
//  CreditCardsCreditCardsInteractor.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//
import RxSwift

class CreditCardsInteractor: CreditCardsInteractorInput {

    weak var output: CreditCardsInteractorOutput!
    var disposeBag = DisposeBag()
    var repository: CreditCardRepository!
    
    func fetchCreditCards() {
        self.repository.getCreditCards().subscribe(onNext: { (cards) in
            self.output.didFetchCreditCards(cards)
        }, onError: { (error) in
            self.output.failedToFetchCreditCards(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    func destroyCreditCard(creditCardModel: CreditCardModel) {
        self.repository.destroyCreditCard(creditCardModel).subscribe(onNext: { (success) in
            self.output.didDestroyCreditCard(creditCardModel)
        }, onError: { (error) in
            self.output.failedToDestroyCreditCard(error: error)
        }).disposed(by: self.disposeBag)
    }
}
