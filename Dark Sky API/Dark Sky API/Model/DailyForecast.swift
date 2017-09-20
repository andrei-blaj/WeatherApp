//
//  DailyForecast.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 12/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import Foundation


class DailyForecast: CurrentConditions {
    
    var _sunriseTime: Double!
    var _sunsetTime: Double!
    var _moonPhase: Double!
    var _precipIntensityMax: Double!
    var _precipIntensityMaxTime: Double!
    var _precipType: String!
    var _temperatureHigh: Double!
    var _temperatureHighTime: Double!
    var _temperatureLow: Double!
    var _temperatureLowTime: Double!
    
    var sunriseTime: Double { get { return _sunriseTime == nil ? 0.0 : _sunriseTime } set { _sunriseTime = newValue } }
    var sunsetTime: Double { get { return _sunsetTime == nil ? 0.0 : _sunsetTime } set { _sunsetTime = newValue } }
    var moonPhase: Double { get { return _moonPhase == nil ? 0.0 : _moonPhase } set { _moonPhase = newValue } }
    var precipIntensityMax: Double { get { return _precipIntensityMax == nil ? 0.0 : _precipIntensityMax } set { _precipIntensityMax = newValue } }
    var precipIntensityMaxTime: Double { get { return _precipIntensityMaxTime == nil ? 0.0 : _precipIntensityMaxTime } set { _precipIntensityMaxTime = newValue } }
    var temperatureHigh: Double { get { return _temperatureHigh == nil ? 0.0 : _temperatureHigh } set { _temperatureHigh = newValue } }
    var temperatureHighTime: Double { get { return _temperatureHighTime == nil ? 0.0 : _temperatureHighTime } set { _temperatureHighTime = newValue } }
    var precipType: String { get { return _precipType == nil ? "" : _precipType } set { _precipType = newValue } }
    var temperatureLow: Double { get { return _temperatureLow == nil ? 0.0 : _temperatureLow } set { _temperatureLow = newValue } }
    var temperatureLowTime: Double { get { return _temperatureLowTime == nil ? 0.0 : _temperatureLowTime } set { _temperatureLowTime = newValue } }
    
}
