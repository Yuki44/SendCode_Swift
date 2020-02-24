//
//  CarEditFormCarEditFormViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import Eureka

class FormValidationError: LocalizedError {
    var message: String!
    init(msg: String) {
        self.message = msg
    }
    
    var errorDescription: String? { return self.message }
}

class CarEditFormViewController: FormViewController, CarEditFormViewInput {
  
    var disposeBag = DisposeBag()
    
    var carModel: CarModel!
    var output: CarEditFormViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
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

    // MARK: CarEditFormViewInput
    func setupInitialState() {
        if self.carModel.id > 0 {
            self.title = self.carModel.name
        } else {
            self.title = "Opret Bil".localize()
        }
        
        form +++ Section("Bil information".localize())
            <<< TextRow("nickname"){
                $0.title = "Kaldenavn".localize()
                $0.value = self.carModel.name
                $0.add(rule: RuleRequired(msg: "Du skal udfylde et kaldenavn".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow("platenumber"){
                $0.title = "Nummerplade".localize()
                $0.value = self.carModel.plateNumber
                $0.add(rule: RuleRequired(msg: "Du skal udfylde din bils nummerplade".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
            }
            +++ SelectableSection<ListCheckRow<CreditCardModel>>("Vælg betalingskort".localize(), selectionType: .singleSelection(enableDeselection: true)) {
                $0.tag = "cardlist"
            } <<< LabelRow("fetchingCardsRow") {
                $0.title = "Henter dine kort ...".localize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.fetchCreditCardsRequested()
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
        //self.output.cancelEditCarFormPressed()
    }
    
    @objc func savePressed() {
        let validations = form.validate()
        if validations.count > 0 {
            let firstError = validations.first!
            self.displayError(FormValidationError(msg: firstError.msg))
        } else {
            let model = CarModel()
            let values = form.values()
            
            let section = self.form.sectionBy(tag: "cardlist")! as! SelectableSection<ListCheckRow<CreditCardModel>>
            if let selectedCardRow = section.selectedRow(), let card = selectedCardRow.selectableValue {
                model.creditCardId = card.id
            } else {
                self.displayError(FormValidationError(msg: "Du skal vælge et betalingskort".localize()))
                return
            }
            
            model.id = self.carModel.id
            model.name = values["nickname"] as! String
            model.plateNumber = values["platenumber"] as! String
            
            self.output.saveCarRequested(model)
        }
    }
    
    func displayCreditCards(_ cards: [CreditCardModel]) {
        let section = self.form.sectionBy(tag: "cardlist")!
        section.removeAll()
        
        for card in cards {
            let row = ListCheckRow<CreditCardModel>() { listRow in
                listRow.title = card.name
                listRow.selectableValue = card
                listRow.value = card.id == self.carModel.creditCardId ? card : nil
            }
    
            section <<< row
        }
        
        section <<< ButtonRow() {
            $0.title = "Administrer kort".localize()
            $0.onCellSelection { (cell, row) in
                self.output.manageCreditCardsPressed()
            }
        }
    }
    
    func showNoCreditCards() {
        let section = self.form.sectionBy(tag: "cardlist")!
        section.removeAll()
        
        section <<< LabelRow("fetchingCardsRow") {
            $0.title = "Ingen kort tilføjet".localize()
        }
       
        section <<< ButtonRow() {
            $0.title = "Administrer kort".localize()
            $0.onCellSelection { (cell, row) in
                self.output.manageCreditCardsPressed()
            }
        }
    }
    
}
