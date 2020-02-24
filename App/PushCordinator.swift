//
//  PushCoordinator.swift
//  CarPay
//
//  Created by Rasmus Styrk on 07/01/2020.
//  Copyright © 2020 House of Code ApS. All rights reserved.
//

import UIKit
import FirebaseMessaging
import RxSwift

enum PushMessageType {
    case none
    case pendingPayment
}

class PushCordinator: NSObject {
    var disposeBag = DisposeBag()
    
    var application: UIApplication!
    var repository: PushTokenRepository!
    var sessionManager: SessionManager!
    
    var message: BehaviorSubject<PushMessageType> = BehaviorSubject<PushMessageType>(value: .none)
    
    init(application: UIApplication,
         pushRepostiory: PushTokenRepository,
         sessionManager: SessionManager) {

        super.init()
        
        self.application = application
        self.repository = pushRepostiory
        self.sessionManager = sessionManager
        
        self.sessionManager
            .status
            .subscribe(onNext: { [weak self] (status) in
                switch(status) {
                case .loggedIn:
                    self?.registerForRemoteNotifications()
                    break
                case .loggedOut:
                    // TODO: Remove registration
                    break
                }
            }).disposed(by: self.disposeBag)
    }
    
    func registerForRemoteNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.application.registerUserNotificationSettings(settings)
        }
        
        self.application.registerForRemoteNotifications()
    }
    
    func registerPushToken(_ token: String) {
        self.repository.registerToken(token)
    }
    
    func notifyAboutNewMessage(type: PushMessageType) {
        self.message.onNext(type)
    }
}

extension PushCordinator: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.notifyAboutNewMessage(type: .pendingPayment)
    }
}
