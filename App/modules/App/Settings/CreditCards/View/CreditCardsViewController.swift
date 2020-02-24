//
//  CreditCardsCreditCardsViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 05/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

class CreditCardsViewController: UIViewController, CreditCardsViewInput, AddCreditCardDelegate {

    var output: CreditCardsViewOutput!
    var disposeBag = DisposeBag()
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var creditCards: [CreditCardModel] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Betalingskort".localize()
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        self.tableView = UITableView(frame: self.view.bounds, style: style)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addCreditCardPressed))
        
        output.viewIsReady()
    }
    
    // MARK: DashboardViewInput
    func setupInitialState() {
    }
    
    func carEditFormFinished() {
        self.refreshData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayCreditCards(_ cards: [CreditCardModel]) {
        self.creditCards = cards
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        self.refreshControl.endRefreshing()
        self.showError(error: error).subscribe(onNext: { _ in
            
        }).disposed(by: self.disposeBag)
    }
    
    @objc func refreshData() {
        self.output.refreshRequested()
    }
    
    @objc func addCreditCardPressed() {
        self.output.addCreditCardPressed()
    }
    
    func addCreditCardFinishied() {
        self.refreshData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreditCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Dine kort".localize()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.creditCards.isEmpty {
            return nil
        }
        
        return "Swipe for at slette et kort".localize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditCards.isEmpty ? 1 : self.creditCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.creditCards.isEmpty) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardEmptyItem")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CreditCardEmptyItem")
            }
            
            cell!.textLabel?.text = "Ingen kort tilføjet".localize()
            cell!.accessoryType = .none
            cell!.selectionStyle = .none
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardItem")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CreditCardItem")
            }
            
            let card = self.creditCards[indexPath.row]
            cell!.textLabel?.text = card.name
            cell!.textLabel?.textColor = Theme.primaryTextColor
            cell!.detailTextLabel?.text = "Udløber".localize() + " \(card.cardExpirationDate.formatAsCreditCardExpiration())"
            cell!.detailTextLabel?.textColor = Theme.secondaryTextColor
            cell!.accessoryType = .none
            cell!.selectionStyle = .none
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let card = self.creditCards[indexPath.row]
            
            let alert = UIAlertController(title: card.name,
                                          message: "Vil du slette dette kort?".localize(),
                preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Slet".localize(), style: .destructive, handler: { (action) in
                self.output.destroyCreditCardRequested(creditCardModel: card)
            }))
            
            alert.addAction(UIAlertAction(title: "Annuller".localize(), style: .cancel, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

