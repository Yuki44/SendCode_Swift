//
//  NotificationsNotificationsPresenter.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 27/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

class NotificationsPresenter: NotificationsModuleInput, NotificationsViewOutput, NotificationsInteractorOutput {

    weak var view: NotificationsViewInput!
    var interactor: NotificationsInteractorInput!
    var router: NotificationsRouterInput!

    func viewIsReady() {

    }
}
