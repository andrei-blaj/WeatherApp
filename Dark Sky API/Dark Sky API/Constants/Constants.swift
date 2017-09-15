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

let DEGREE_SIGN = "°"

// Google Places API

let GOOGLE_BASE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
let GOOGLE_INBETWEEN_DATA = "&sensor=true&types=(cities)&key="
let GOOGLE_API_KEY = "AIzaSyCHwX_7njwiT4-g3ZHQp3y9x0Zt_R99kAA"

// https://maps.googleapis.com/maps/api/place/autocomplete/json?input=cluj&sensor=true&types=(cities)&key=AIzaSyD8k5Mih12Nlwdi5ovAqE6qz_x5SFTY_8I
