//
//  TabbedNavigationTabbedNavigationViewController.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

class TabbedNavigationViewController: UIViewController, TabbedNavigationViewInput {

    var output: TabbedNavigationViewOutput!
    var disposeBag = DisposeBag()
    var tabView: TabView!
    var contentView: UIView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView = UIView()
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tabView = TabView()
        self.view.addSubview(self.tabView)
        self.tabView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIDevice.current.hasNotch ? 96 : 65)
        }
        
        self.tabView
            .selectedTab
            .subscribe(onNext: { [weak self] (tab) in
                if let tab = tab {
                    self?.output.changeRouter(tab.identifier)
                }
            }).disposed(by: self.disposeBag)
        
        output.viewIsReady()
    }


    // MARK: TabbedNavigationViewInput
    func setupInitialState() {
    }
    
    func displayRouter(_ router: TabbedRouter) {
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        let controller = router.controllerForTab()
        
        var notify = false
        if !self.children.contains(controller) {
            self.addChild(controller)
            notify = true
        }
        
        self.contentView.addSubview(controller.view)
        controller.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let navController = controller as? UINavigationController {
            for controller in navController.viewControllers {
                if let reloadableController = controller as? ReloadableTabbedController {
                    reloadableController.reloadTab()
                }
            }
        } else if let reloadableController = controller as? ReloadableTabbedController {
            reloadableController.reloadTab()
        }
        
        if notify {
            controller.didMove(toParent: self)
        }
    }
}
