//
//  TabbedNavigationTabbedNavigationPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 24/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//
import RxSwift

protocol ReloadableTabbedController {
    func reloadTab()
}

protocol TabbedRouter {
    func start()
    func cleanUp()
    func controllerForTab() -> UIViewController
}

class TabbedNavigationPresenter: TabbedNavigationModuleInput, TabbedNavigationViewOutput, TabbedNavigationInteractorOutput {
    
    weak var view: TabbedNavigationViewInput!
    var interactor: TabbedNavigationInteractorInput!
    var router: TabbedNavigationRouterInput!
    var repository: DataRepository!
    var pushCordinator: PushCordinator!
    
    var sessionManager: SessionManager!
    var disposeBag = DisposeBag()
    
    var tabbedRouters: [TabIdentifier: TabbedRouter] = [:]
    var currentIdentifier: TabIdentifier = .dashboard

    deinit {
        // Need to make sure all tabs is released
        self.tabbedRouters.forEach { (identifier, router) in
            let controller = router.controllerForTab()
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            router.cleanUp()
        }
    }
    
    func viewIsReady() {
        
        self.tabbedRouters[.dashboard] = DashboardRouter(repository: self.repository,
                                                         sessionManager: self.sessionManager)
        
        self.tabbedRouters[.cars] = CarsRouter(repository: self.repository,
                                               sessionManager: self.sessionManager)
        
        
        self.tabbedRouters[.services] = ServicesRouter(repository: self.repository,
                                                       sessionManager: self.sessionManager)
        
        /*
        self.tabbedRouters[.notifications] = NotificationsRouter(repository: self.repository,
                                                                 sessionManager: self.sessionManager)
        */
        self.tabbedRouters[.settings] = SettingsRouter(repository: self.repository,
                                                       sessionManager: self.sessionManager)
        
        self.tabbedRouters.forEach { (key, router) in
            router.start()
        }
        
        self.changeRouter(.dashboard)
        
        self.pushCordinator.message.subscribe(onNext: { (pushType) in
            switch(pushType) {
            case .none:
                break
            case .pendingPayment:
                self.changeRouter(.dashboard)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func logout() {
        self.router.logout()
    }
    
    func changeRouter(_ identifier: TabIdentifier) {
        print("Selected identifier: \(identifier)")
        
        if let router = self.tabbedRouters[identifier] {
            self.view.displayRouter(router)
        }
    }
}
