//
//  LocationModel.swift
//  DaShuttle
//
//  Created by John M Cruz on 11/17/18.
//  Copyright © 2018 John M Cruz. All rights reserved.
//

import Foundation
import Firebase

struct LocationModel : Codable {
    var id : Int
    var lastMessage : String
    var lastTimestamp : Date
    var lat : Double
    var lng : Double
    var tag : String
    
    init(id: Int, lat: Double, lng: Double, message: String, timestamp: TimeInterval, tag: String) {
        self.id = id
        self.lat = lat
        self.lng = lng
        self.lastMessage = message
        self.lastTimestamp = Date(timeIntervalSince1970: timestamp)
        self.tag = tag
    }
    
    init(snapshot: DataSnapshot) {
        let item = snapshot.value as! [String: AnyObject]
        self.id = item["id"] as! Int
        self.lat = item["lat"] as! Double
        self.lng = item["lng"] as! Double
        self.lastMessage = item["lastMessage"] as! String
        self.lastTimestamp = Date(timeIntervalSince1970: item["lastTimestamp"] as! TimeInterval)
        self.tag = item["tag"] as! String
    }
}
