//
//  AllWeatherModels.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 09.11.2022.
//

import UIKit

// MARK: - AllWeatherModels
struct AllWeatherModels {
    
    // CurrentWeather
    var asOfCurrent: String = ""
    var cloudCoverCurrent: Double = 0.0
    var conditionCodeCurrent: String = "Launch"
    var daylightCurrent: Bool = true
    var humidityCurrent: Double = 0.0
    var precipitationIntensityCurrent: Double = 0.0
    var pressureCurrent: Double = 0.0
    var temperatureCurrent: Double?
    var temperatureApparentCurrent: Double = 0.0
    var uvIndexCurrent: Int = 0
    var visibilityCurrent: Double = 0.0
    var windDirectionCurrent: Int = 0
    var windSpeedCurrent: Double = 0.0
    var latitudeCurrent: Double = 0.0
    var longitudeCurrent: Double = 0.0
    
    // HourlyWeather
    var cloudCoverHourly: [Double] = [0.0]
    var conditionCodeHourly: [String] = [""]
    var daylightHourly: [Bool] = [true]
    var forecastStartHourly: [String] = [""]
    var humidityHourly: [Double] = [0.0]
    var precipitationAmountHourly: [Double] = [0.0]
    var precipitationChanceHourly: [Double] = [0.0]
    var precipitationTypeHourly: [String] = [""]
    var pressureHourly: [Double] = [0.0]
    var snowfallIntensityHourly: [Double] = [0.0]
    var temperatureHourly: [Double] = [0.0]
    var temperatureApparentHourly: [Double] = [0.0]
    var uvIndexHourly: [Int] = [0]
    var visibilityHourly: [Double] = [0.0]
    var windDirectionHourly: [Int] = [0]
    var windSpeedHourly: [Double] = [0.0]
    
    // Daily Weather
    var conditionCodeDaily: [String] = [""]
    var maxUvIndexDaily: [Int] = [0]
    var precipitationAmountDaily: [Double] = [0.0]
    var precipitationChanceDaily: [Double] = [0.0]
    var precipitationTypeDaily: [String] = [""]
    var snowfallAmountDaily: [Double] = [0.0]
    var sunriseDaily: [String?] = []
    var sunsetDaily: [String?] = [""]
    var temperatureMaxDaily: [Double] = [0.0]
    var temperatureMinDaily: [Double] = [0.0]
    var forecastStartDaily: [String] = [""]
    var cloudCoverDaily: [Double] = [0.0]
    var humidityDaily: [Double] = [0.0]
    var windDirectionDaily: [Int] = [0]
    var windSpeedDaily: [Double] = [0.0]
    
    // Weather Alerts
    var weatherAlertDescription: [String?] = []
    var weatherAlertImportance: [String?] = []
}
