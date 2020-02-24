//
//  AppDelegate.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 18/11/2019.
//  Copyright © 2019 Rasmus Styrk. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import SwiftyBeaver
import FBSDKCoreKit
import FBSDKLoginKit
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var appCordinator: AppCordinator!
    var repository: DataRepository!
    var sessionManager: SessionManager!
    var pushCordinator: PushCordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Theme stuff
        Theme.applyAppearance()
        
        // Init firebase
        FirebaseApp.configure()
        
        // Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    
        // Configure logging
        let console = ConsoleDestination()  // log to Xcode Console
        log.addDestination(console)
        log.info("Realm Database path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        // Fire up
        let repository = DataRepositoryFactory().repository()
        let sessionManager = SessionManager(repository: repository)
        
        self.pushCordinator = PushCordinator(application: application,
                                               pushRepostiory: repository,
                                               sessionManager: sessionManager)
        
        self.appCordinator = AppCordinator(repository: repository,
                                           sessionManager: sessionManager,
                                           pushCordinator: self.pushCordinator)
        
        if #available(iOS 13.0, *) {
            // On IOS 13 we use the UISceneSession stuff
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.appCordinator?.start(in: self.window!)
        }
        
        // Init messaging
        Messaging.messaging().delegate = self
    
        // Check for cold start messages
        if let options = launchOptions {
            if options[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
                self.pushCordinator.notifyAboutNewMessage(type: .pendingPayment)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushCordinator.notifyAboutNewMessage(type: .pendingPayment)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        messaging.subscribe(toTopic: "ios")
        self.pushCordinator.registerPushToken(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        self.pushCordinator.notifyAboutNewMessage(type: .pendingPayment)
    }
}

