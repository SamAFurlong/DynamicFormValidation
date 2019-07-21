//
//  ReachabilityChecker.swift
//  DynamicFormValidation
//
//  Created by Samuel Furlong on 7/21/19.
//  Copyright © 2019 Samuel Furlong. All rights reserved.
//

import Foundation
import Reachability
protocol ReachabilityChecker{
    var whenReachable: ((Reachability)->())? {get}
    var whenUnreachable: ((Reachability)->())? {get}
    
    func registerForReachibilityAlerts()
}
extension ReachabilityChecker where Self:AlertPresenter {
    func registerForReachibilityAlerts(){
        let reachability = Reachability()!
        reachability.whenReachable = whenReachable
        reachability.whenUnreachable = whenUnreachable
    }
}
