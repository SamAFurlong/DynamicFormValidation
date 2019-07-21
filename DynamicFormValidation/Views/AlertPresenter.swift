//
//  AlertProvider.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/19/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import UIKit
protocol AlertPresenter {
    func presentAlert(with text:String)
}
extension AlertPresenter where Self:UIViewController{
    func presentAlert(with text:String){
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
