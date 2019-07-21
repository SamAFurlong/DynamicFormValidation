//
//  Firestore.swift
//  Inclusive
//
//  Created by Samuel Furlong on 7/14/19.
//  Copyright © 2019 Sam Furlong. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import ReactiveSwift
struct PartyAPI {
    static let database = Firestore.firestore()
    enum PartyUploadError: Error{
        case imageUploadFail
        var localizedDescription: String {
            switch self {
            case .imageUploadFail:
                return "The parties image could not be uploaded to firebase"

            }
        }
        
    }
    func addPartyData(for party:Party)->SignalProducer<(), PartyUploadError>{
        return SignalProducer{observer, lifetime in
            DispatchQueue.global(qos: .userInteractive).async {
                if let documentID = party.documentID{
                    Firestore.firestore().collection("Parties")
                        .document(documentID)
                        .setData(party.json)
                } else {
                    Firestore.firestore().collection("Parties").addDocument(data: party.json)
                    
                }
                // update the image
                let storageRef = Storage.storage().reference().child("PartyImages").child((party.documentID ?? "") + ".png")
                guard let partyImage = party.image else {
                    return
                }
                if let imageData = partyImage.pngData() {
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/PNG"
                    let uploadTask = storageRef.putData(imageData, metadata: metadata, completion:{ (metadata, error) in
                        guard let _ = error else {
                            observer.send(value: ())
                            observer.sendCompleted()
                            return
                        }
                         observer.send(error: .imageUploadFail)
                     
                    })
                    uploadTask.resume()
                    
                }
            }
        }
        
    }
}
