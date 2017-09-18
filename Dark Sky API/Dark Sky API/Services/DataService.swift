//
//  DataService.swift
//  Dark Sky API
//
//  Created by Andrei-Sorin Blaj on 11/09/2017.
//  Copyright © 2017 Andrei-Sorin Blaj. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class DataService {
    
    static let instance = DataService()
    
    let currentConditions = CurrentConditions()
    
    // User Settings
    var currentMeasuringUnit: String!
    var userSettings = [UserSettings]()
    
    var hourlySummary: String!
    var hourlyIcon: String!
    var hourlyForecast = [HourlyForecast]()
    
    var dailySummary: String!
    var dailyIcon: String!
    var dailyForecast = [DailyForecast]()
    
    func downloadDarkSkyData(completed: @escaping DownloadComplete) {
        
        let darkSkyURL = getDarkSkyURL(forLatitude: Location.instance.latitude!, andLongitude: Location.instance.longitude!)
        
        Alamofire.request(darkSkyURL).responseJSON { (response) in
            if let result = response.result.value as? Dictionary<String, Any> {
                
                if let currently = result["currently"] as? Dictionary<String, Any> {
                    // Current Weather
                    if let time = currently["time"] as? Double { self.currentConditions.time = time }
                    if let summary = currently["summary"] as? String { self.currentConditions.summary = summary }
                    if let icon = currently["icon"] as? String { self.currentConditions.icon = icon }
                    if let precipProbability = currently["precipProbability"] as? Double { self.currentConditions.precipProbability = precipProbability }
                    if let precipIntensity = currently["precipIntensity"] as? Double { self.currentConditions.precipIntensity = precipIntensity }
                    if let temperature = currently["temperature"] as? Double { self.currentConditions.temperature = temperature }
                    if let apparentTemperature = currently["apparentTemperature"] as? Double { self.currentConditions.apparentTemperature = apparentTemperature }
                    if let humidity = currently["humidity"] as? Double { self.currentConditions.humidity = humidity }
                    if let pressure = currently["pressure"] as? Double { self.currentConditions.pressure = pressure }
                    if let windSpeed = currently["windSpeed"] as? Double { self.currentConditions.windSpeed = windSpeed }
                    if let windGust = currently["windGust"] as? Double { self.currentConditions.windGust = windGust }
                    if let windBearing = currently["windBearing"] as? Double { self.currentConditions.windBearing = windBearing }
                    if let cloudCover = currently["cloudCover"] as? Double { self.currentConditions.cloudCover = cloudCover }
                }
                
                // There is also and "minutely" dictionary, but in this case it is not necessary
                
                if let hourly = result["hourly"] as? Dictionary<String, Any> {
                    if let summary = hourly["summary"] as? String { self.hourlySummary = summary }
                    if let icon = hourly["icon"] as? String { self.hourlyIcon = icon }
                    if let data = hourly["data"] as? [Dictionary<String, Any>] {
                        // Weather by the hour
                        var cnt: Int = 0
                        for currently in data {
                            let currentHour = HourlyForecast()
                            
                            cnt += 1
                            
                            if let time = currently["time"] as? Double { currentHour.time = time }
                            if let summary = currently["summary"] as? String { currentHour.summary = summary }
                            if let icon = currently["icon"] as? String { currentHour.icon = icon }
                            if let precipProbability = currently["precipProbability"] as? Double { currentHour.precipProbability = precipProbability }
                            if let precipIntensity = currently["precipIntensity"] as? Double { currentHour.precipIntensity = precipIntensity }
                            if let temperature = currently["temperature"] as? Double { currentHour.temperature = temperature }
                            if let apparentTemperature = currently["apparentTemperature"] as? Double { currentHour.apparentTemperature = apparentTemperature }
                            if let humidity = currently["humidity"] as? Double { currentHour.humidity = humidity }
                            if let pressure = currently["pressure"] as? Double { currentHour.pressure = pressure }
                            if let windSpeed = currently["windSpeed"] as? Double { currentHour.windSpeed = windSpeed }
                            if let windGust = currently["windGust"] as? Double { currentHour.windGust = windGust }
                            if let windBearing = currently["windBearing"] as? Double { currentHour.windBearing = windBearing }
                            if let cloudCover = currently["cloudCover"] as? Double { currentHour.cloudCover = cloudCover }
                            
                            self.hourlyForecast.append(currentHour)
                            
                            if cnt == 36 {
                                break
                            }
                        }
                    }
                }
                
                if let daily = result["daily"] as? Dictionary<String, Any> {
                    if let summary = daily["summary"] as? String { self.dailySummary = summary }
                    if let icon = daily["icon"] as? String { self.dailyIcon = icon }
                    if let data = daily["data"] as? [Dictionary<String, Any>] {
                        // Daily weather
                        for day in data {
                            let currentDay = DailyForecast()

                            if let time = day["time"] as? Double { currentDay.time = time }
                            if let summary = day["summary"] as? String { currentDay.summary = summary }
                            if let icon = day["icon"] as? String { currentDay.icon = icon }
                            if let precipProbability = day["precipProbability"] as? Double { currentDay.precipProbability = precipProbability }
                            if let precipIntensity = day["precipIntensity"] as? Double { currentDay.precipIntensity = precipIntensity }
                            if let precipType = day["precipType"] as? String { currentDay.precipType = precipType }
                            if let humidity = day["humidity"] as? Double { currentDay.humidity = humidity }
                            if let pressure = day["pressure"] as? Double { currentDay.pressure = pressure }
                            if let windSpeed = day["windSpeed"] as? Double { currentDay.windSpeed = windSpeed }
                            if let windGust = day["windGust"] as? Double { currentDay.windGust = windGust }
                            if let windBearing = day["windBearing"] as? Double { currentDay.windBearing = windBearing }
                            if let cloudCover = day["cloudCover"] as? Double { currentDay.cloudCover = cloudCover }
                            
                            if let sunriseTime = day["sunriseTime"] as? Double { currentDay.sunriseTime = sunriseTime }
                            if let sunsetTime = day["sunsetTime"] as? Double { currentDay.sunsetTime = sunsetTime }
                            if let moonPhase = day["moonPhase"] as? Double { currentDay.moonPhase = moonPhase }
                            if let precipIntensityMax = day["precipIntensityMax"] as? Double { currentDay.precipIntensityMax = precipIntensityMax }
                            if let precipIntensityMaxTime = day["precipIntensityMaxTime"] as? Double { currentDay.precipIntensityMaxTime = precipIntensityMaxTime }
                            if let temperatureHigh = day["temperatureHigh"] as? Double { currentDay.temperatureHigh = temperatureHigh }
                            if let temperatureHighTime = day["temperatureHighTime"] as? Double { currentDay.temperatureHighTime = temperatureHighTime }
                            if let temperatureLow = day["temperatureLow"] as? Double { currentDay.temperatureLow = temperatureLow }
                            if let temperatureLowTime = day["temperatureLowTime"] as? Double { currentDay.temperatureLowTime = temperatureLowTime }

                            self.dailyForecast.append(currentDay)

                        }
                    }
                }
                
                completed(true)
            } else {
                completed(false)
            }
        }
        
    }
    
    func getLocationData(placemark: CLPlacemark) {
        if let x = placemark.thoroughfare { Location.instance.street = x }
        if let x = placemark.country { Location.instance.country = x }
        if let x = placemark.administrativeArea { Location.instance.region = x }
        if let x = placemark.locality { Location.instance.city = x }
        if let x = placemark.isoCountryCode { Location.instance.countryCode = x }
    }
    
    // Conversions
    func convertTo(unit: String) {
        currentConditions.temperature = convertTemp(t: currentConditions.temperature, toUnit: unit)
        for hour in hourlyForecast {
            hour.temperature = convertTemp(t: hour.temperature, toUnit: unit)
        }
        for day in dailyForecast {
            day.temperature = convertTemp(t: day.temperature, toUnit: unit)
            day.temperatureLow = convertTemp(t: day.temperatureLow, toUnit: unit)
            day.temperatureHigh = convertTemp(t: day.temperatureHigh, toUnit: unit)
        }
    }
    
    func convertTemp(t: Double, toUnit: String) -> Double {
        if toUnit == "F" {
            return Double((t * (9 / 5)) + 32)
        } else {
            return Double((t - 32) * (5 / 9))
        }
    }
    
}
