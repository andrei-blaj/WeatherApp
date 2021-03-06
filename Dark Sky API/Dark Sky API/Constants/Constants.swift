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

// Day dictionary
let DAY_DICTIONARY = [1 : "Monday", 2 : "Tuesday", 3 : "Wednesday", 4 : "Thurday", 5 : "Friday", 6 : "Saturday", 7 : "Sunday"]

// Dark Sky API
let BASE_URL = "https://api.darksky.net/forecast/"
let API_KEY = "55ea38a504bf2cc73c48d08f25791e5d/"
let AUTO = "auto"
let SI = "si"
let US = "us"

func getDarkSkyURL(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) -> String {
    let url = "\(BASE_URL)\(API_KEY)\(latitude),\(longitude)?units=\(SI)"
    return url
}

// TimeZoneDB API

let TIMEZONE_BASE_URL = "http://api.timezonedb.com/v2/get-time-zone?key="
let KEY = "S3TM2I0XC7O3"
let FORMAT = "&format=json&by=position&lat="
let OTHER = "&lng="

// example url: http://api.timezonedb.com/v2/get-time-zone?key=S3TM2I0XC7O3&format=json&by=position&lat=47&lng=23

func getTimeZoneUrl(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) -> String {
        let url = "\(TIMEZONE_BASE_URL)\(KEY)\(FORMAT)\(latitude)\(OTHER)\(longitude)"
        return url
}

// Sunrise Sunset API

let SUNRISE_SUNSET_BASE_URL = "https://api.sunrise-sunset.org/json"
let COORD1 = "?lat="
let COORD2 = "&lng="
let ADDITIONAL = "&date=today&formatted=1"

func getSSUrl(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) -> String {
    let url = "\(SUNRISE_SUNSET_BASE_URL)\(COORD1)\(latitude)\(COORD2)\(longitude)\(ADDITIONAL)"
    return url
}

// Special Characters
let DEGREE_SIGN = "°"

// Notification Constants
let NOTIF_MEASURING_UNIT_CHANGED = Notification.Name("measuringUnitChanged")
let NOTIF_SHOW_HIDE_SWITCH_CHANGED = Notification.Name("showHideSwitchChanged")
