//
//  TransactionDetailTransactionDetailViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift
import MTSlideToOpen
import AVFoundation

struct TransactionDetailListItem {
    var title: String
    var detailText: String
    var cellStyle: UITableViewCell.CellStyle
}

class TransactionDetailViewController: UIViewController, TransactionDetailViewInput {
    var mode: TransactionDetailMode!
    var transactionModel: TransactionModel!
    var output: TransactionDetailViewOutput!
    var disposeBag = DisposeBag()
    var tableView: UITableView!
    
    var transactionDetails: [TransactionDetailListItem] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = self.transactionModel.title
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = .insetGrouped
        } else {
            style = .plain
        }
        
        self.tableView = UITableView(frame: self.view.bounds, style: style)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if self.mode == .readOnly {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                     target: self,
                                                                     action: #selector(exportButtonPressed))
        }
        
        if self.mode == .acceptMode {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuller".localize(),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(cancelPressed))
        
            
            
            let acceptButton = MTSlideToOpenView(frame: CGRect(x: 26, y: 0, width: self.view.frame.width-(26*2), height: 56))
            acceptButton.sliderCornerRadius = 22
            acceptButton.sliderViewTopDistance = 6
            acceptButton.sliderBackgroundColor = .white
            acceptButton.slidingColor = .white
            acceptButton.textLabel.textColor = Theme.primaryTextColor
            acceptButton.labelText = "Betal \(self.transactionModel.amount.formatAsCurrency()) nu"
            acceptButton.thumnailImageView.image = UIImage(named: "ic_arrow")
            acceptButton.thumnailImageView.backgroundColor = Theme.primaryTextColor
            acceptButton.delegate = self
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 120))
            footerView.backgroundColor = .clear
    
            footerView.addSubview(acceptButton)
            acceptButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(self.view.frame.width-(26*2))
                make.height.equalTo(56)
            }
            
            self.view.addSubview(footerView)
            
            footerView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(120)
            }
        }
        
        output.viewIsReady()
    }
    
    @objc func cancelPressed() {
        self.output.cancelPressed()
    }

    @objc func exportButtonPressed() {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageToShare = [screenshot!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }

    // MARK: TransactionDetailViewInput
    func setupInitialState() {
        self.populateTable(with: nil)
        if self.transactionModel.carId > 0 {
            self.output.fetchCar(id: self.transactionModel.carId)
        }
    }
    
    func displayCar(_ car: CarModel) {
        self.populateTable(with: car)
    }
    
    func displayError(_ error: Error) {
        self.showError(error: error).subscribe(onNext: { _ in
            
        }).disposed(by: self.disposeBag)
    }
    
    func populateTable(with car: CarModel?) {
        self.transactionDetails.removeAll()
        self.transactionDetails.append(
            TransactionDetailListItem(title: "Sted".localize(),
                                      detailText: self.transactionModel.title,
                                      cellStyle: .value1))
        
        self.transactionDetails.append(
            TransactionDetailListItem(title: "Dato".localize(),
                                      detailText: self.transactionModel.date.formatAsString(),
                                      cellStyle: .value1))
        
        self.transactionDetails.append(
            TransactionDetailListItem(title: "Beløb".localize(),
                                      detailText: self.transactionModel.amount.formatAsCurrency(),
                                      cellStyle: .value1))
        
        self.transactionDetails.append(
            TransactionDetailListItem(title: "Bil".localize(),
                                      detailText: car?.name ?? "-",
                cellStyle: .value1))
        
        self.transactionDetails.append(
            TransactionDetailListItem(title: "Beskrivelse".localize(),
                                      detailText: self.transactionModel.text,
                                      cellStyle: .subtitle))
        
        self.tableView.reloadData()
    }
}

extension TransactionDetailViewController: MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.output.acceptTransaction(self.transactionModel)
    }
}

extension TransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detaljer".localize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionDetail = self.transactionDetails[indexPath.row]

        let identifier = "TransactionDetailItem\(transactionDetail.cellStyle.rawValue)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: transactionDetail.cellStyle, reuseIdentifier: identifier)
        }
        
        cell!.textLabel?.text = transactionDetail.title
        cell!.textLabel?.textColor = Theme.primaryTextColor
        
        cell!.detailTextLabel?.text = transactionDetail.detailText
        cell!.detailTextLabel?.textColor = Theme.secondaryTextColor
        cell!.detailTextLabel?.numberOfLines = 0
        cell!.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        cell!.accessoryType = .none
        cell!.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Transactions id: \(self.transactionModel.id)"
    }
}
