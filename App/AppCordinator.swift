//
//  AppCordinator.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 23/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

/// App Coordinator
///
/// Coordinates the main app state, ie if you are logged in or not
class AppCordinator {
    
    var disposeBag = DisposeBag()
    
    /// Current App State
    enum AppState {
        case splash
        case login
        case app
    }
    
    /// The window where we cordinate the view in
    private var window: UIWindow!
    
    var repository: DataRepository
    var sessionManager: SessionManager
    var pushCoordinator: PushCordinator
    
    ///
    init(repository: DataRepository, sessionManager: SessionManager, pushCordinator: PushCordinator) {
        self.repository = repository
        self.sessionManager = sessionManager
        self.pushCoordinator = pushCordinator
    }
 
    /// Starts the cordinator and sets the app state
    func start(in window: UIWindow) {
        self.window = window
        setRootController(state: .splash)
        self.repository.logEvent(event: "APP_OPEN")
        
        self.sessionManager
            .status
            .subscribe(onNext: { [weak self] (status) in
                switch(status) {
                case .loggedIn:
                    self?.setRootController(state: .app)
                    break
                case .loggedOut:
                    self?.setRootController(state: .login)
                    break
                }
            }).disposed(by: self.disposeBag)
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] (timer) in
            if let status = try? self?.sessionManager.status.value() {
                if status == .loggedOut {
                    self?.setRootController(state: .login)
                }
            }
        }
    }
    
    /// Sets a new root view controller on the window
    private func setRootController(state: AppState) {
        
        log.info("Setting app state: \(state)")
        
        self.window.rootViewController?.view.removeFromSuperview()
        self.window.rootViewController = nil
        
        switch state {
        case .splash:
            self.window.rootViewController = UIStoryboard(name: "SplashStoryboard", bundle: nil).instantiateInitialViewController()
            break
        case .login:
            let loginRouter = LoginSelectionRouter(sessionManager: self.sessionManager,
                                                   analyticsRepository: self.repository)
            loginRouter.start(in: self.window)
            break
        case .app:
            let tabbedRouter = TabbedNavigationRouter(repository: self.repository,
                                                      sessionManager: self.sessionManager,
                                                      pushCordinator: self.pushCoordinator)
            tabbedRouter.start(in: self.window)
            break
        }
        
        self.window.makeKeyAndVisible()
    }
}
