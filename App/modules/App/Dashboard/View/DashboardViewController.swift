//
//  DashboardDashboardViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

enum TransactionSectionType {
    case pending
    case other
}

struct TransactionSection {
    var title: String
    var type: TransactionSectionType
    var transactions: [TransactionModel]
}

class DashboardViewController: UIViewController, DashboardViewInput, TransactionDetailRouterDelegate, ReloadableTabbedController {
    var output: DashboardViewOutput!
    var disposeBag = DisposeBag()
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var transactionSections: [TransactionSection] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Dashboard".localize()
        
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
        output.viewIsReady()
    }
    
    func transactionDetailRouterCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func transactionDetailRouterFinished() {
        self.dismiss(animated: true, completion: {
            self.refreshData()
        })
    }
    
    // MARK: DashboardViewInput
    func setupInitialState() {
        
        /*
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        
        let headline = UILabel()
        headline.text = "Status".localize().uppercased()
        headline.textColor = Theme.primaryTextColor
        headline.font = UIFont.systemFont(ofSize: 15.0)

        statusView.addSubview(headline)
        
        headline.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        
        let status = UILabel()
        status.text = "Afventer transaktion".localize()
        status.textColor = Theme.secondaryTextColor
        status.font = UIFont.systemFont(ofSize: 14.0)
        statusView.addSubview(status)
        
        status.snp.makeConstraints { (make) in
            make.top.equalTo(headline.snp_bottomMargin).offset(15)
            make.left.equalTo(20)
        }
        
        self.tableView.tableHeaderView = statusView
         */
    }
    
    func displayTransactions(_ transactions: [TransactionModel]) {
        
        var transactionMap: [TransactionSectionType: [TransactionModel]] = [:]
        for transaction in transactions {
            if transaction.status == "pending" {
                if transactionMap[.pending] != nil {
                    transactionMap[.pending]!.append(transaction)
                } else {
                    transactionMap[.pending] = [transaction]
                }
            } else {
                if transactionMap[.other] != nil {
                    transactionMap[.other]!.append(transaction)
                } else {
                    transactionMap[.other] = [transaction]
                }
            }
        }

        var sections: [TransactionSection] = []
        
        sections.append(TransactionSection(title: "Afventer godkendelse".localize(),
                                           type: .pending,
                                           transactions: transactionMap[.pending] ?? []))
        
        sections.append(TransactionSection(title: "Seneste Transaktioner".localize(),
                                           type: .other,
                                           transactions: transactionMap[.other] ?? []))
        
        self.transactionSections = sections
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        
        if let nextPendingTransaction = transactionMap[.pending]?.first {
            self
                .output
                .pendingTransactionDetailPressed(transactionModel: nextPendingTransaction)
        }
    }
    
    func displayError(_ error: Error) {
        self.refreshControl.endRefreshing()
        self.showError(error: error).subscribe(onNext: { _ in
            
        }).disposed(by: self.disposeBag)
    }
    
    @objc func refreshData() {
        self.output.refreshRequested()
    }
    
    func reloadTab() {
        self.refreshData()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.transactionSections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionSections[section].transactions.isEmpty ? 1 : self.transactionSections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.transactionSections[indexPath.section].transactions.isEmpty) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransactionEmptyItem")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "TransactionEmptyItem")
            }
            
            cell!.textLabel?.text = "Ingen transaktioner".localize()
            cell!.accessoryType = .none
            cell!.selectionStyle = .none
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransactionItem")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "TransactionItem")
            }
            
            let transaction = self.transactionSections[indexPath.section].transactions[indexPath.row]
            cell!.textLabel?.text = transaction.title
            cell!.textLabel?.textColor = Theme.primaryTextColor
            cell!.detailTextLabel?.text = transaction.amount.formatAsCurrency()
            cell!.detailTextLabel?.textColor = Theme.secondaryTextColor
            cell!.accessoryType = .disclosureIndicator
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !self.transactionSections[indexPath.section].transactions.isEmpty else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = self.transactionSections[indexPath.section]
        
        if section.type == .pending {
            self
                .output
                .pendingTransactionDetailPressed(transactionModel: self.transactionSections[indexPath.section].transactions[indexPath.row])
        } else {
            self
                .output
                .transactionDetailsPressed(transactionModel: self.transactionSections[indexPath.section].transactions[indexPath.row])
        }
        
    }
}
