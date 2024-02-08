//
//  AllWeatherData.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 09.11.2022.
//

import UIKit

// MARK: - AllWeatherData
struct AllWeatherData: Decodable {
    let currentWeather: CurrentWeather
    let forecastHourly: ForecastHourly
    let forecastDaily: ForecastDaily
    let weatherAlerts: WeatherAlerts?
}

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    let name: String
    let metadata: Metadata
    let asOf: String
    let cloudCover: Double
    let conditionCode: String
    let daylight: Bool
    let humidity: Double
    let precipitationIntensity: Double
    let pressure: Double
    let pressureTrend: String
    let temperature: Double
    let temperatureApparent: Double
    let temperatureDewPoint: Double
    let uvIndex: Int
    let visibility: Double
    let windDirection: Int
    let windGust: Double
    let windSpeed: Double
}

struct Metadata: Decodable {
    let latitude: Double
    let longitude: Double
}

// MARK: - ForecastHourly
struct ForecastHourly: Decodable {
    let hours: [Hours]
}

struct Hours: Decodable {
    let cloudCover: Double
    let conditionCode: String
    let daylight: Bool
    let forecastStart: String
    let humidity: Double
    let precipitationAmount: Double
    let precipitationChance: Double
    let precipitationType: String
    let pressure: Double
    let pressureTrend: String
    let snowfallIntensity: Double
    let temperature: Double
    let temperatureApparent: Double
    let temperatureDewPoint: Double
    let uvIndex: Int
    let visibility: Double
    let windDirection: Int
    let windGust: Double
    let windSpeed: Double
}

// MARK: - ForecastDaily
struct ForecastDaily: Decodable {
    let days: [Days]
}

struct Days: Decodable {
    let forecastStart: String
    let conditionCode: String
    
    let daytimeForecast: DaytimeForecast
    
    let maxUvIndex: Int
    let moonPhase: String?
    let moonrise: String?
    let moonset: String?
    
    let overnightForecast: OvernightForecast?
    
    let precipitationAmount: Double
    let precipitationChance: Double
    let precipitationType: String
    
    let snowfallAmount: Double
    let solarMidnight: String?
    let solarNoon: String?
    let sunrise: String?
    let sunset: String?
    let temperatureMax: Double
    let temperatureMin: Double
}

struct DaytimeForecast: Decodable {
    let cloudCover: Double
    let conditionCode: String
    let forecastStart: String
    let humidity: Double
    let precipitationAmount: Double
    let precipitationChance: Double
    let precipitationType: String
    let snowfallAmount: Double
    let windDirection: Int
    let windSpeed: Double
}

struct OvernightForecast: Decodable {
    let cloudCover: Double
    let conditionCode: String
    let humidity: Double
    let precipitationAmount: Double
    let precipitationChance: Double
    let precipitationType: String
    let snowfallAmount: Double
    let windDirection: Int
    let windSpeed: Double
}

// MARK: - WeatherAlerts
struct WeatherAlerts: Decodable {
    let alerts: [Alerts?]
}

struct Alerts: Decodable {
    let description: String?
    let importance: String?
}
