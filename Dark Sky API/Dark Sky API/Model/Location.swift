//
//  Location.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 12/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    static let instance = Location()
    
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var _city: String!
    var _street: String?
    var _zip: String?
    var _country: String!
    var _region: String! // State or County
    var _countryCode: String!
    
    // Setters & Getters
    
    var street: String {
        get {
            if _street == nil {
                _street = ""
            }
            return _street!
        } set {
            _street = newValue
        }
    }

    var zip: String {
        get {
            if _zip == nil {
                _zip = ""
            }
            return _zip!
        } set {
            _zip = newValue
        }
    }

    var country: String {
        get {
            if _country == nil {
                _country = ""
            }
            return _country
        } set {
            _country = newValue
        }
    }
    
    var region: String {
        get {
            if _region == nil {
                _region = ""
            }
            return _region
        } set {
            _region = newValue
        }
    }
    
    var city: String {
        get {
            if _city == nil {
                _city = ""
            }
            return _city
        } set {
            _city = newValue
        }
    }
    
    var countryCode: String {
        get {
            if _countryCode == nil {
                _countryCode = ""
            }
            return _countryCode
        } set {
            _countryCode = newValue
        }
    }
    
}
