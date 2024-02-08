//
//  CurentTemperature.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 24.07.2022.
//

import UIKit

struct Converter {
    
    func convertTemperature(_ temperature: Double) -> String {
        let temperatureUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.temperature) as? Bool
        
        if temperatureUserDef == true || temperatureUserDef == nil {
            let celsius = Int(temperature.rounded())
            return "\(celsius) ºC"
        } else {
            let fahrenheit = Int((temperature * 1.8) + 32)
            if fahrenheit >= 0 {
                return "\(fahrenheit) ºF"
            } else {
                return"\(fahrenheit) ºF"
            }
        }
    }
    
    func convertSpeed(_ speed: Double) -> String {
        let speedUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.speed) as? Bool

        if speedUserDef == true || speedUserDef == nil {
            let metersPerSecond = speed / 3.6
            return "\(round(metersPerSecond * 10) / 10) \(L10nSettings.speedButtonLeftValueText)"
        } else {
            let yardPerSec = (speed / 3.6) * 1.093613
            return "\(round(yardPerSec * 10) / 10) \(L10nSettings.speedButtonRightValueText)"
        }
    }
    
    func convertPressure(_ pressure: Double) -> String {
        let pressureUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.pressure) as? Bool
        
        if pressureUserDef == true || pressureUserDef == nil {
            let mmHg = pressure / 1.333
            return "\(round(mmHg * 10) / 10) \(L10nSettings.pressureButtonLeftValueText)"
        } else {
            let hPa = pressure
            return "\(Int(hPa)) \(L10nSettings.pressureButtonRightValueText)"
        }
    }
    
    func convertPrecipitation(_ precipitation: Double) -> String {
        let precipitationIsDefault = UserDefaults.standard.value(forKey: UserDefaultsKeys.precipitation) as? Bool
        
        if precipitationIsDefault == true || precipitationIsDefault == nil {
            let mm = precipitation
            return "\(round(mm * 10) / 10) \(L10nSettings.precipitationButtonLeftValueText)"
        } else {
            let inch = precipitation * 0.0394
            return "\(round(inch * 10) / 10) \(L10nSettings.precipitationButtonRightValueText)"
        }
    }
    
    func convertKmToMil(_ data: Double) -> String {
        let distanceIsDefault = UserDefaults.standard.value(forKey: UserDefaultsKeys.distance) as? Bool
        
        if distanceIsDefault == true || distanceIsDefault == nil {
            let km = round((data / 1000) * 10) / 10
            return "\(km) \(L10nSettings.distanceButtonLeftValueText)"
        } else {
            let ml = data * 0.000621371
            return "\(round(ml * 10) / 10) \(L10nSettings.distanceButtonRightValueText)"
        }
    }
    
    func convertTemperatureToDouble(_ temperature: Double) -> Double {
        let temperatureUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.temperature) as? Bool
        
        if temperatureUserDef == true || temperatureUserDef == nil {
            let celsius = temperature
            return celsius
        } else {
            let fahrenheit = temperature * 1.8 + 32
            if fahrenheit >= 0 {
                return fahrenheit
            } else {
                return fahrenheit
            }
        }
    }
    
}

