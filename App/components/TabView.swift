//
//  TabView.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

enum TabIdentifier {
    case dashboard
    case cars
    case services
    case notifications
    case settings
}

class Tab {
    var identifier: TabIdentifier
    var normalImage: UIImage
    var selectedImage: UIImage
    
    var button: UIButton?
    
    init(identifier: TabIdentifier, normalImage: UIImage, selectedImage: UIImage) {
        self.identifier = identifier
        self.normalImage = normalImage
        self.selectedImage = selectedImage
    }
}

class TabView: UIView {
    
    var tabs: [Tab] = []
    var tabButtons: [UIButton] = []
    var selectedTab: BehaviorSubject<Tab?> = BehaviorSubject(value: nil)
    var tabContainer: UIStackView!
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTabs()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureTabs()
        self.setupView()
    }
    
    func configureTabs() {
        self.tabs.append(Tab(identifier: .dashboard,
                             normalImage: UIImage(named: "dashboard-i")!,
                             selectedImage: UIImage(named: "dashboard-a")!))
        
        self.tabs.append(Tab(identifier: .cars,
                             normalImage: UIImage(named: "car-i")!,
                             selectedImage: UIImage(named: "car-a")!))
    
        self.tabs.append(Tab(identifier: .services,
                             normalImage: UIImage(named: "notifications-i")!,
                             selectedImage: UIImage(named: "notifications-a")!))
        
        /*
        self.tabs.append(Tab(identifier: .notifications,
                             normalImage: UIImage(named: "notifications-i")!,
                             selectedImage: UIImage(named: "notifications-a")!))
        */
        self.tabs.append(Tab(identifier: .settings,
                             normalImage: UIImage(named: "settings-i")!,
                             selectedImage: UIImage(named: "settings-a")!))
    }
    
    func setupView() {
        
        let backgroundView = UIView()
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().offset(-12)
        }
        
        backgroundView.backgroundColor = .white
        
        self.tabContainer = UIStackView()
        self.addSubview(self.tabContainer)
        self.tabContainer.axis = .horizontal
        self.tabContainer.alignment = .fill
        self.tabContainer.distribution = .equalSpacing
        self.tabContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
        
        for tab in self.tabs {
            let button = UIButton()
            button.setImage(tab.normalImage, for: .normal)
            button.setImage(tab.selectedImage, for: .selected)
            button.rx.tap.bind { [weak self] in
                self?.selectTab(tab)
            }.disposed(by: self.disposeBag)
            self.tabContainer.addArrangedSubview(button)
            tab.button = button
        }
        
        if let firstTab = self.tabs.first {
            self.selectTab(firstTab)
        }
    }
    
    func selectTab(_ tab: Tab) {
        self.tabs.forEach { $0.button?.isSelected = false }
        tab.button?.isSelected = true
        self.selectedTab.onNext(tab)
    }
}
