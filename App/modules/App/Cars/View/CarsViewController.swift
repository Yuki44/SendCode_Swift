//
//  CarsCarsViewController.swift
//  CarPay
//
//  Created by Rasmus Styrk on 04/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

class CarsViewController: UIViewController, CarsViewInput, CarEditFormDelegate {

    var output: CarsViewOutput!
    var disposeBag = DisposeBag()
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var cars: [CarModel] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = "#F2F0E9".color()
        self.title = "Dine Biler".localize()
        
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
                                                                 action: #selector(addCarPressed))
        
        output.viewIsReady()
    }
  
    // MARK: DashboardViewInput
    func setupInitialState() {
    }
    
    func carEditFormFinished() {
        self.refreshData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayCars(_ cars: [CarModel]) {
        self.cars = cars
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
    
    @objc func addCarPressed() {
        self.output.addCarPressed()
    }
}

extension CarsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Vælg bil".localize()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.cars.isEmpty {
            return nil
        }
        
        return "Swipe for at slette en bil".localize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.isEmpty ? 1 : self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.cars.isEmpty) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CarEmptyItem")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CarEmptyItem")
            }
            
            cell!.textLabel?.text = "Ingen biler tilføjet".localize()
            cell!.accessoryType = .none
            cell!.selectionStyle = .none
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CarItem")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CarItem")
            }
            
            let car = self.cars[indexPath.row]
            cell!.textLabel?.text = car.name
            cell!.textLabel?.textColor = Theme.primaryTextColor
            cell!.detailTextLabel?.text = car.plateNumber
            cell!.detailTextLabel?.textColor = Theme.secondaryTextColor
            cell!.accessoryType = .disclosureIndicator
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !self.cars.isEmpty else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.output.editCarPressed(carModel: self.cars[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let car = self.cars[indexPath.row]
            
            let alert = UIAlertController(title: car.name,
                                          message: "Vil du slette bilen med nummerplade".localize() + " \(car.plateNumber)?",
                preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Slet".localize(), style: .destructive, handler: { (action) in
                self.output.destroyCarRequested(carModel: car)
            }))
            
            alert.addAction(UIAlertAction(title: "Annuller".localize(), style: .cancel, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

