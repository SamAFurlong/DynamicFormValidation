//
//  PartyInputViewModelProtocol.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/19/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import ReactiveSwift
protocol PartyInputViewModelProtocol: LocationViewModel{
    // properties that will be observered by the view
    var initialParty:Party? {get}
    var name:MutableProperty<String> {get}
    var description:MutableProperty<String> {get}
    var date:MutableProperty<Date> {get}
    var startTime:MutableProperty<Date> {get}
    var endTime:MutableProperty<Date> {get}
    var image:MutableProperty<UIImage> {get}
    var canBeDone: Property<Bool> {get}
    var currentParty: Property<Party> {get}
    var error:Property<PartyInputViewModel.PartyInputErrors?> {get}
    var doneAction: Action<Party,(),PartyAPI.PartyUploadError> {get}
}
