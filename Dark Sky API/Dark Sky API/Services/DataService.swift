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
                    self.currentConditions.time = currently["time"] as! Double
                    self.currentConditions.summary = currently["summary"] as! String
                    self.currentConditions.icon = currently["icon"] as! String
                    self.currentConditions.precipProbability = currently["precipProbability"] as! Double
                    // self.currentConditions.precipIntensity = currently["precipIntensity"] as! Double
                    self.currentConditions.temperature = currently["temperature"] as! Double
                    // self.currentConditions.apparentTemperature = currently["apparentTemperature"] as! Double
                    self.currentConditions.humidity = currently["humidity"] as! Double
                    self.currentConditions.pressure = currently["pressure"] as! Double
                    self.currentConditions.windSpeed = currently["windSpeed"] as! Double
                    self.currentConditions.windGust = currently["windGust"] as! Double
                    self.currentConditions.windBearing = currently["windBearing"] as! Double
                    self.currentConditions.cloudCover = currently["cloudCover"] as! Double
                }
                
                // There is also and "minutely" dictionary, but in this case it is not necessary
                
                if let hourly = result["hourly"] as? Dictionary<String, Any> {
                    if let summary = hourly["summary"] as? String { self.hourlySummary = summary }
                    if let icon = hourly["icon"] as? String { self.hourlyIcon = icon }
                    if let data = hourly["data"] as? [Dictionary<String, Any>] {
                        // Weather by the hour
                        for currently in data {
                            let currentHour = HourlyForecast()
                            
                            currentHour.time = currently["time"] as! Double
                            currentHour.summary = currently["summary"] as! String
                            currentHour.icon = currently["icon"] as! String
                            currentHour.precipProbability = currently["precipProbability"] as! Double
                            // currentHour.precipIntensity = currently["precipIntensity"] as! Double
                            currentHour.temperature = currently["temperature"] as! Double
                            // currentHour.apparentTemperature = currently["apparentTemperature"] as! Double
                            currentHour.humidity = currently["humidity"] as! Double
                            currentHour.pressure = currently["pressure"] as! Double
                            currentHour.windSpeed = currently["windSpeed"] as! Double
                            currentHour.windGust = currently["windGust"] as! Double
                            currentHour.windBearing = currently["windBearing"] as! Double
                            currentHour.cloudCover = currently["cloudCover"] as! Double
                            
                            self.hourlyForecast.append(currentHour)
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

                            currentDay.time = day["time"] as! Double
                            currentDay.summary = day["summary"] as! String
                            currentDay.icon = day["icon"] as! String
                            currentDay.precipProbability = day["precipProbability"] as! Double
                            // currentDay.precipIntensity = day["precipIntensity"] as! Double
                            // currentDay.precipType = day["precipType"] as! String
                            currentDay.humidity = day["humidity"] as! Double
                            currentDay.pressure = day["pressure"] as! Double
                            currentDay.windSpeed = day["windSpeed"] as! Double
                            currentDay.windGust = day["windGust"] as! Double
                            currentDay.windBearing = day["windBearing"] as! Double
                            currentDay.cloudCover = day["cloudCover"] as! Double

                            currentDay.sunriseTime = day["sunriseTime"] as! Double
                            currentDay.sunsetTime = day["sunsetTime"] as! Double
                            currentDay.moonPhase = day["moonPhase"] as! Double
                            currentDay.precipIntensityMax = day["precipIntensityMax"] as! Double
                            // currentDay.precipIntensityMaxTime = day["precipIntensityMaxTime"] as! Double
                            currentDay.temperatureHigh = day["temperatureHigh"] as! Double
                            currentDay.temperatureHighTime = day["temperatureHighTime"] as! Double
                            currentDay.temperatureLow = day["temperatureLow"] as! Double
                            currentDay.temperatureLowTime = day["temperatureLowTime"] as! Double

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
    
}
