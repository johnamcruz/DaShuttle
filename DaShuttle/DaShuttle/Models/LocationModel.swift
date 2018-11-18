//
//  LocationModel.swift
//  DaShuttle
//
//  Created by John M Cruz on 11/17/18.
//  Copyright © 2018 John M Cruz. All rights reserved.
//

import Foundation

struct LocationModel : Codable {
    var lastTimestamp : Date
    var lat : Double
    var lng : Double
    
    init(lat: Double, lng: Double, timestamp: TimeInterval) {
        self.lat = lat
        self.lng = lng
        self.lastTimestamp = Date(timeIntervalSince1970: timestamp)
    }
}
