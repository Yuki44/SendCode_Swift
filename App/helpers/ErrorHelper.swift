//
//  ErrorHelper.swift
//  HuntPlan
//
//  Created by Rasmus Styrk on 23/11/2019.
//  Copyright © 2019 House of Code ApS. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    /// Shows an alert for a given error
    /// Use the observeable to know when the user pressed ok
    func showError(error: Error) -> Observable<Void> {
        
        return Observable.create { (observable) -> Disposable in
            
            let alert = UIAlertController(title: "Fejl".localize(),
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Ok".localize(), style: .default, handler: { (action) in
                observable.onNext(())
                observable.onCompleted()
            }))
        
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func confirm(title: String, msg: String = "Er du sikker?".localize()) -> Observable<Void> {
        
        return Observable.create { (observable) -> Disposable in
            
            let alert = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ok".localize(), style: .destructive, handler: { (action) in
                observable.onNext(())
                observable.onCompleted()
            }))
            
            alert.addAction(UIAlertAction(title: "Annuller".localize(), style: .default, handler: { (action) in
                observable.onCompleted()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
