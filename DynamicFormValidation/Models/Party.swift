//
//  Party.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/14/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import UIKit
struct Party{
    let name: String?
    let address: String?
    let description: String?
    let documentID: String?
    let startHour: Int?
    let startMinute: Int?
    let endHour: Int?
    let endMinute: Int?
    let date: String?
    var image: UIImage?
    let role:Role
    let timeState:TimeState
    let numInvites:Int?
    let numCheckIns:Int?
    let numRSVPs:Int?
    /// constructor that takes in json from the api and produces a party
    ///
    /// - Parameter json: the json which will be parsed to fill this party object
    init(json: [String:Any]){
        self.description = json["Description"] as? String
        self.name = json["Name"] as? String
        self.address = json["Location"] as? String
        self.date = json["date"] as? String
        self.startMinute = json["startMinute"] as? Int
        self.startHour = json["startHour"] as? Int
        self.endMinute = json["endMinute"] as? Int
        self.endHour = json["endHour"] as? Int
        self.documentID = json["partyId"] as? String
        self.numInvites = json["numInvites"] as? Int
        self.numCheckIns = json["numCheckIns"] as? Int
        self.numRSVPs = json["numRsvps"] as? Int
        
        
        
        
        let isActive = json["isActive"] as? Bool
        let isStale = json["isStale"] as? Bool
        
        if let isActive = isActive , let isStale = isStale  {
            if(isActive && !isStale){
                self.timeState = .present
            }
            else if(!isActive && !isStale){
                self.timeState = .future
            }
            else{
                self.timeState = .past
            }
        }
        else {
            self.timeState = .past
        }
        
        switch json["hostType"] as? String {
        case "bouncer":
            self.role = .bouncer
        case "coHost":
            self.role = .coHost
        default:
            self.role = .owner
        }
        
        
        
        
        
    }
    /// This method is intended for the creation of a new party on the client side
    ///
    /// - Parameters:
    ///   - name: party name
    ///   - address: party address
    ///   - description: party description
    ///   - startHour: the hour the party will start
    ///   - startMinute: the minute the party will start
    ///   - endHour: the hour the party will end
    ///   - endMinute: the minute the party will end
    ///   - date: the date of the party
    ///   - image: the image that represents this party
    ///   - role: the role of the given user within this party
    ///   - timeState: whether or not this party will take place in the past present or future
    ///   - documentID: the document id of this party
    init(name:String?, address:String?, description:String?, startHour:Int?, startMinute:Int?, endHour:Int?, endMinute:Int?, date:String?, image:UIImage?, documentID:String?){
        self.name = name
        self.address = address
        self.description = description
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.date = date
        self.image = image
        self.role = .owner
        self.timeState = .future
        self.numRSVPs = 0
        self.numCheckIns = 0
        self.numInvites = 0
        self.documentID = documentID
        
    }
    enum Role {
        case bouncer
        case coHost
        case owner
    }
    enum TimeState {
        case past
        case present
        case future
    }
    
    var json:[String:Any] {
        let name = self.name ?? ""
        let address = self.address ?? ""
        let description = self.description ?? ""
        let startMinute = String(self.startMinute ?? 0)
        let startHour =  String(self.startHour ?? 0)
        let endMinute = String(self.endMinute ?? 0)
        let endHour = String(self.endHour ?? 0)
        let date = self.date ?? ""
        let numInvites = String(self.numInvites ?? 0)
        let numRSVPs = String(self.numRSVPs ?? 0)
        let numCheckedIn = String(self.numCheckIns ?? 0)
        return ["Name": name, "Location": address, "Description" : description, "startMinute": startMinute, "startHour": startHour, "endMinute": endMinute, "endHour":endHour, "date": date, "numInvites": numInvites, "numRsvps": numRSVPs , "numCheckedIn" : numCheckedIn]
    }
    
}
