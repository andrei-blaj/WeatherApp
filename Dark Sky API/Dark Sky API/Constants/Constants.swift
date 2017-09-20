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

// TimeZoneDB

let TIMEZONE_BASE_URL = "http://api.timezonedb.com/v2/get-time-zone?key="
let KEY = "S3TM2I0XC7O3"
let FORMAT = "&format=json&by=position&lat="
let OTHER = "&lng="

// example url: http://api.timezonedb.com/v2/get-time-zone?key=S3TM2I0XC7O3&format=json&by=position&lat=47&lng=23

func getTimeZoneUrl(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) -> String {
        let url = "\(TIMEZONE_BASE_URL)\(KEY)\(FORMAT)\(latitude)\(OTHER)\(longitude)"
        return url
}

// Special Characters
let DEGREE_SIGN = "°"

// Notification Constants
let NOTIF_MEASURING_UNIT_CHANGED = Notification.Name("measuringUnitChanged")
