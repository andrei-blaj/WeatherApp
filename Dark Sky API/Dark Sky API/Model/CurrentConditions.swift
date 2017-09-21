//
//  CurrentConditions.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 12/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import Foundation

class CurrentConditions {
    
    var _time: Int!
    var _summary: String!
    var _icon: String!
    var _precipIntensity: Double!
    var _precipProbability: Double!
    var _temperature: Double!
    var _apparentTemperature: Double!
    var _humidity: Double!
    var _pressure: Double!
    var _windSpeed: Double!
    var _windGust: Double!
    var _windBearing: Double!
    var _cloudCover: Double!
    
    // Setters & Getters
    var time: Int { get { return _time == nil ? 0 : _time } set { _time = newValue } }
    var summary: String { get { return _summary == nil ? "" : _summary } set { _summary = newValue } }
    var icon: String { get { return _icon == nil ? "" : _icon } set { _icon = newValue } }
    var precipIntensity: Double { get { return _precipIntensity == nil ? 0.0 : _precipIntensity } set { _precipIntensity = newValue } }
    var precipProbability: Double { get { return _precipProbability == nil ? 0.0 : _precipProbability } set { _precipProbability = newValue } }
    var temperature: Double { get { return _temperature == nil ? 0.0 : _temperature } set { _temperature = newValue } }
    var apparentTemperature: Double { get { return _apparentTemperature == nil ? 0.0 : _apparentTemperature } set { _apparentTemperature = newValue } }
    var humidity: Double { get { return _humidity == nil ? 0.0 : _humidity } set { _humidity = newValue } }
    var pressure: Double { get { return _pressure == nil ? 0.0 : _pressure } set { _pressure = newValue } }
    var windSpeed: Double { get { return _windSpeed == nil ? 0.0 : _windSpeed } set { _windSpeed = newValue } }
    var windGust: Double { get { return _windGust == nil ? 0.0 : _windGust } set { _windGust = newValue } }
    var windBearing: Double { get { return _windBearing == nil ? 0.0 : _windBearing } set { _windBearing = newValue } }
    var cloudCover: Double { get { return _cloudCover == nil ? 0.0 : _cloudCover } set { _cloudCover = newValue } }
    
}
