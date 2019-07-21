//
//  LocationViewModel.swift
//  DynamicFormValidation
//
//  Created by Samuel Furlong on 7/21/19.
//  Copyright © 2019 Samuel Furlong. All rights reserved.
//

import Foundation
import ReactiveSwift
protocol LocationViewModel {
    var location:MutableProperty<String>{get}
}
