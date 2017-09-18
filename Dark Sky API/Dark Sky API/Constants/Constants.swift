//
//  Constants.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 11/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import Foundation
import CoreLocation

typealias DownloadComplete = (_ completed: Bool) -> ()

// Dark Sky API Data
let BASE_URL = "https://api.darksky.net/forecast/"
let API_KEY = "55ea38a504bf2cc73c48d08f25791e5d/"
let AUTO = "auto"
let SI = "si"
let US = "us"

func getDarkSkyURL(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) -> String {
    let url = "\(BASE_URL)\(API_KEY)\(latitude),\(longitude)?units=\(SI)"
    return url
}

// Special Characters
let DEGREE_SIGN = "°"

// Notification Constants
let NOTIF_MEASURING_UNIT_CHANGED = Notification.Name("measuringUnitChanged")
