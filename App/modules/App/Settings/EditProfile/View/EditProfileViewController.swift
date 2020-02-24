//
//  EditProfileEditProfileViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 22/12/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class EditProfileViewController: FormViewController, EditProfileViewInput {

    var disposeBag = DisposeBag()
    var output: EditProfileViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Rediger Profil".localize()
        self.view.backgroundColor = Theme.backgroundColor
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
            
            if let newPassword1 = values["newPassword1"] as? String, let newPassword2 = values["newPassword2"] as? String {
                if newPassword1 != newPassword2 {
                    self.displayError(FormValidationError(msg: "De nye adgangskoder stemmer ikke overens".localize()))
                    return
                }
                
                self.output.updateUser(name: values["nickname"] as! String, newPassword: newPassword1)
            } else {
                self.output.updateUser(name: values["nickname"] as! String, newPassword: nil)
            }
        }
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
    }

    func displayUser(_ user: UserModel) {
        form.removeAll()
        
        form +++ Section("Generelt".localize())
            <<< TextRow("nickname"){
                $0.title = "Navn".localize()
                $0.value = user.name
                $0.add(rule: RuleRequired(msg: "Du skal udfylde dit navn".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
        }
            <<< TextRow("email"){
                $0.title = "E-mail".localize()
                $0.value = user.email
                $0.disabled = Condition(booleanLiteral: true)
                $0.add(rule: RuleRequired(msg: "Du skal udfylde din e-mail".localize(), id: nil))
                $0.validationOptions = .validatesOnChange
        }
        /*<<< PasswordRow("currentPassword") {
            $0.title = "Nuværende adgangskode".localize()
            $0.add(rule: RuleRequired(msg: "Du skal udfylde din nuværende adgangskode".localize(), id: nil))
        }*/
        +++ Section("Skift adgangskode".localize())
            <<< PasswordRow("newPassword1") {
                $0.title = "Ny adgangskode".localize()
        }
            <<< PasswordRow("newPassword2") {
                $0.title = "Gentag adgangskode".localize()
        }
    }

    // MARK: EditProfileViewInput
    func setupInitialState() {

    }
}
