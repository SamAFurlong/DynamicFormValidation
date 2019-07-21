//
//  PartyInputViewModel.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/16/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Reachability
class PartyInputViewModel: PartyInputViewModelProtocol{
    enum PartyInputErrors {
        case startTimeEndTime
        case dateInPast
        case startInPast
        case failedToSubmit
        case unexpectedError
        var description:String {
            switch self {
            case .startTimeEndTime:
                return "Your Party's Start Time Must be Before It's End Time"
            case .dateInPast:
                return "You selected a date for your party that is in the past"
            case .startInPast:
                return "You selected a start time for your party in the past"
            case .failedToSubmit:
                return "There was an issue submitting your party"
            case .unexpectedError:
                return "An unexpected error occurred while validating your parties date and time values"
            }
        }
    }
    enum NavigateToScreen {
        case success
        case main
        case failure
        case none
    }
    
    let initialParty:Party?
    let name:MutableProperty<String>
    let description:MutableProperty<String>
    let location:MutableProperty<String>
    let date:MutableProperty<Date>
    let startTime:MutableProperty<Date>
    let endTime:MutableProperty<Date>
    let image:MutableProperty<UIImage?>
    let canBeDone: Property<Bool>
    let currentParty: Property<Party>
    let error:Property<PartyInputErrors?>
    let doneAction: Action<Party,(),PartyAPI.PartyUploadError>
    
    
    /// This initializer handles the case when an existing party is being edited
    ///
    /// - Parameter party: the existing party to be edited
    init(party:Party? = nil){
        
        initialParty = party
        description = MutableProperty(party?.description ?? "")
        name = MutableProperty(party?.name ?? "")
        location = MutableProperty(party?.address ?? "")
        date = MutableProperty(Date())
        endTime = MutableProperty(Date().adding(hours:2))
        startTime = MutableProperty(Date().adding(hours:1))
        image = MutableProperty(party?.image)
        
        doneAction = Action{ party in
            //upload the party
            return PartyAPI().addPartyData(for: party)
        }
       
        currentParty = Property.combineLatest(name, description, location, date, startTime, endTime, image, MutableProperty(initialParty?.documentID)).map{(arg) -> Party in
            
            
            let (name, description, location, date, startTime, endTime, image, documentID) = arg
            return Party(name: name, address: location, description: description, startHour: startTime.hour, startMinute: startTime.minute, endHour: endTime.hour, endMinute: endTime.hour, date: date.firestoreString, image: image, documentID: documentID)
            
        }
        
        error = Property.combineLatest(startTime,endTime,date).map{(arg) -> PartyInputErrors? in
            let (startTime,endTime,date) = arg
            // intrisictly a party cannot have a start time greater than end time
            // for now we are assuning parties start and end on the same day
            if startTime > endTime {return .startTimeEndTime}
        
            guard let currentStartDateTime = date.setTime(to: startTime.hour ?? 0, and: startTime.minute ?? 0) else {
                // this error occurs if the date somehow overflowed etc.
                // if the date extensions are used correctly this should never occur
                return .unexpectedError
            }
            //first display the error to let the user know to update the date picker
            if date.compare(with: Date(), only: .day) < 0{
                return .dateInPast
            }
            // if the user has a valid date then this if statement means that the date is today and
            // the start time has passed so they must change the start time field
            if  currentStartDateTime < Date() {
                return .startInPast
            }
            
            return nil
            
        }
        let canBeDoneValidator:Property<Bool> = Property.combineLatest(name, description, location, error, image)
            .map{name, description, location, error, image in
                
                return name != ""
                    && location != ""
                    && description != ""
                    && error == nil
                    && image != nil
        }
        canBeDone = Property(initial: false, then:canBeDoneValidator.producer)
        
        
    }
    
    
    
    
}


