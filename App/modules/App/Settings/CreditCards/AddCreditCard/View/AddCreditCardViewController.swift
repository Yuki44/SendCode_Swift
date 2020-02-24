//
//  AddCreditCardAddCreditCardViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class AddCreditCardViewController: FormViewController, AddCreditCardViewInput {
   
    var disposeBag = DisposeBag()
    var output: AddCreditCardViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Tilføj kort".localize()
        self.tableView!.backgroundColor = .clear
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuller".localize(),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(cancelPressed))
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gem".localize(),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(savePressed))
        

        output.viewIsReady()
    }
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func savePressed() {
        let validations = form.validate()
        if validations.count > 0 {
            let firstError = validations.first!
            self.displayError(FormValidationError(msg: firstError.msg))
        } else {
            let values = form.values()
            
            let model = CreditCardModel()
            model.name = values["nickname"] as! String
            model.cardholderName = values["cardholder_name"] as! String
            model.cardNumber = "\(values["cardnumber"] as! Int)"
            model.cardExpirationDate = values["cardexpiration"] as! Date
            model.cardCvc = "\(values["cardcvc"] as! Int)"
         
            self.output.saveCardRequested(card: model)
        }
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }
    
    // MARK: AddCreditCardViewInput
    func setupInitialState() {
        
        form +++ Section("Generelt".localize())
            <<< TextRow("nickname"){
                $0.title = "Kaldenavn".localize()
                $0.value = ""//self.carModel.name
                $0.add(rule: RuleRequired(msg: "Du skal udfylde et kaldenavn".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
        }
        form +++ Section("Kortoplysninger".localize())
            <<< TextRow("cardholder_name"){
                $0.title = "Kortholder".localize()
                $0.add(rule: RuleRequired(msg: "Du skal udfylde kortholder".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
            }
            <<< IntRow("cardnumber"){
                $0.title = "Kortnummer".localize()
                //row.useFormatterDuringInput = true
                //row.formatter = CreditCardFormatter()
                //row.useFormatterDuringInput = true
                $0.add(rule: RuleRequired(msg: "Du skal udfylde kortnummer".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
            }
            <<< DateRow("cardexpiration"){
                $0.title = "Udløbsdato"
                $0.value = Date()
                $0.dateFormatter = DateFormatter.CreditCardFormatter()
                $0.add(rule: RuleRequired(msg: "Du skal udfylde udløbsdato".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
            }
            <<< IntRow("cardcvc"){
                $0.title = "CVC".localize()
                $0.add(rule: RuleRequired(msg: "Du skal udfylde CVC".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
        }
    }
}
