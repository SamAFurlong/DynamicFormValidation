//
//  AlertProvider.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/19/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import UIKit
import Reachability
protocol AlertPresenter: ReachabilityChecker {
    func presentAlert(with text:String)
    
}
extension AlertPresenter where Self:UIViewController{
    var whenReachable: ((Reachability)->())? {
        return nil
    }
    var whenUnreachable: ((Reachability)->())? {
        return { _ in
            self.presentAlert(with: "It appears as though you are not connected to the internet, connect and try again.")
        }
    }
    func presentAlert(with text:String){
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
