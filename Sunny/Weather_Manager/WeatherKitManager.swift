//
//  WeatherKitManager.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 15.08.2022.
//

import UIKit
import Alamofire
import CoreLocation

protocol WeatherKitManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherKitManager: WeatherKitManager, weather: AllWeatherModels)
    func didUpdateHourlyForecast(_ weatherKitManager: WeatherKitManager, hourlyForecast: HourlyForecastModel)
}

extension WeatherKitManagerDelegate {
    func didUpdateHourlyForecast(_ weatherKitManager: WeatherKitManager, hourlyForecast: HourlyForecastModel) { }
}

// MARK: - WeatherKitManager
struct WeatherKitManager {
    
    private let header: HTTPHeaders = [.authorization(bearerToken: JWT.tokenForWeatherKit)]
    
    private let weatherKitURL = "https://weatherkit.apple.com/api/v1/weather/en-US"
    
    private let allParameters: Parameters = ["dataSets": "currentWeather, forecastHourly, forecastDaily, weatherAlerts",
                                             "country": "US"]
    private let hourlyParameters: Parameters = ["dataSets": "forecastHourly"]

    weak var weatherKitManagerDelegate: WeatherKitManagerDelegate?
    
    // MARK: - Fetch Weather
    func fetchWeather(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        
        let url = weatherKitURL + "/" + "\(lat)" + "/" + "\(long)"
        
        AF.request(url,
                   method: .get,
                   parameters: allParameters,
                   headers: header).responseDecodable(of: AllWeatherData.self) { response in
            if response.response?.statusCode == 401 {
                self.fetchWeather(lat, long)
            }
            guard let data = response.data else { return }
            if let weather = self.parseAllWeatherJSON(data) {
                self.weatherKitManagerDelegate?.didUpdateWeather(self, weather: weather)
            }
        }
    }
    
    private func parseAllWeatherJSON(_ weatherData: Data) -> AllWeatherModels? {
        do {
            let allWeather = try JSONDecoder().decode(AllWeatherData.self, from: weatherData)
        
            // Current Weather
            let asOfCurrent = allWeather.currentWeather.asOf
            let cloudCoverCurrent = allWeather.currentWeather.cloudCover
            let conditionCodeCurrent = allWeather.currentWeather.conditionCode
            let daylightCurrent = allWeather.currentWeather.daylight
            let humidityCurrent = allWeather.currentWeather.humidity
            let precipitationIntensityCurrent = allWeather.currentWeather.precipitationIntensity
            let pressureCurrent = allWeather.currentWeather.pressure
            let temperatureCurrent = allWeather.currentWeather.temperature
            let temperatureApparentCurrent = allWeather.currentWeather.temperatureApparent
            let uvIndexCurrent = allWeather.currentWeather.uvIndex
            let visibilityCurrent = allWeather.currentWeather.visibility
            let windDirectionCurrent = allWeather.currentWeather.windDirection
            let windSpeedCurrent = allWeather.currentWeather.windSpeed
            let latitudeCurrent = allWeather.currentWeather.metadata.latitude
            let longitudeCurrent = allWeather.currentWeather.metadata.longitude
            
            // Hourly Weather
            let cloudCoverHourly = allWeather.forecastHourly.hours.map { $0.cloudCover }
            let conditionCodeHourly = allWeather.forecastHourly.hours.map { $0.conditionCode }
            let daylightHourly = allWeather.forecastHourly.hours.map { $0.daylight }
            let forecastStartHourly = allWeather.forecastHourly.hours.map { $0.forecastStart }
            let humidityHourly = allWeather.forecastHourly.hours.map { $0.humidity }
            let precipitationAmountHourly = allWeather.forecastHourly.hours.map { $0.precipitationAmount }
            let precipitationChanceHourly = allWeather.forecastHourly.hours.map { $0.precipitationChance }
            let precipitationTypeHourly = allWeather.forecastHourly.hours.map { $0.precipitationType }
            let pressureHourly = allWeather.forecastHourly.hours.map { $0.pressure }
            let snowfallIntensityHourly = allWeather.forecastHourly.hours.map { $0.snowfallIntensity }
            let temperatureHourly = allWeather.forecastHourly.hours.map { $0.temperature }
            let temperatureApparentHourly = allWeather.forecastHourly.hours.map { $0.temperatureApparent }
            let uvIndexHourly = allWeather.forecastHourly.hours.map { $0.uvIndex }
            let visibilityHourly = allWeather.forecastHourly.hours.map { $0.visibility }
            let windDirectionHourly = allWeather.forecastHourly.hours.map { $0.windDirection }
            let windSpeedHourly = allWeather.forecastHourly.hours.map { $0.windSpeed }
            
            // Daily Weather
            let conditionCodeDaily = allWeather.forecastDaily.days.map { $0.conditionCode }
            let maxUvIndexDaily = allWeather.forecastDaily.days.map { $0.maxUvIndex }
            let precipitationAmountDaily = allWeather.forecastDaily.days.map { $0.precipitationAmount }
            let precipitationChanceDaily = allWeather.forecastDaily.days.map { $0.precipitationChance }
            let precipitationTypeDaily = allWeather.forecastDaily.days.map { $0.precipitationType }
            let snowfallAmountDaily = allWeather.forecastDaily.days.map { $0.snowfallAmount }
            let sunriseDaily = allWeather.forecastDaily.days.map { $0.sunrise }
            let sunsetDaily = allWeather.forecastDaily.days.map { $0.sunset }
            let temperatureMaxDaily = allWeather.forecastDaily.days.map { $0.temperatureMax }
            let temperatureMinDaily = allWeather.forecastDaily.days.map { $0.temperatureMin }
            let forecastStartDaily = allWeather.forecastDaily.days.map { $0.forecastStart }
            let cloudCoverDaily = allWeather.forecastDaily.days.map { $0.daytimeForecast.cloudCover }
            let humidityDaily = allWeather.forecastDaily.days.map { $0.daytimeForecast.humidity }
            let windDirectionDaily = allWeather.forecastDaily.days.map { $0.daytimeForecast.windDirection }
            let windSpeedDaily = allWeather.forecastDaily.days.map { $0.daytimeForecast.windSpeed }
            
            //Weather Alerts
            let weatherAlertDescription = allWeather.weatherAlerts?.alerts.map { $0?.description } ?? []
            let weatherAlertImportance = allWeather.weatherAlerts?.alerts.map { $0?.importance } ?? []
            
            // Weather Data
            let weatherData = AllWeatherModels(asOfCurrent: asOfCurrent,
                                               cloudCoverCurrent: cloudCoverCurrent,
                                               conditionCodeCurrent: conditionCodeCurrent,
                                               daylightCurrent: daylightCurrent,
                                               humidityCurrent: humidityCurrent,
                                               precipitationIntensityCurrent: precipitationIntensityCurrent,
                                               pressureCurrent: pressureCurrent,
                                               temperatureCurrent: temperatureCurrent,
                                               temperatureApparentCurrent: temperatureApparentCurrent,
                                               uvIndexCurrent: uvIndexCurrent,
                                               visibilityCurrent: visibilityCurrent,
                                               windDirectionCurrent: windDirectionCurrent,
                                               windSpeedCurrent: windSpeedCurrent,
                                               latitudeCurrent: latitudeCurrent,
                                               longitudeCurrent: longitudeCurrent,
                                               cloudCoverHourly: cloudCoverHourly,
                                               conditionCodeHourly: conditionCodeHourly,
                                               daylightHourly: daylightHourly,
                                               forecastStartHourly: forecastStartHourly,
                                               humidityHourly: humidityHourly,
                                               precipitationAmountHourly: precipitationAmountHourly,
                                               precipitationChanceHourly: precipitationChanceHourly,
                                               precipitationTypeHourly: precipitationTypeHourly,
                                               pressureHourly: pressureHourly,
                                               snowfallIntensityHourly: snowfallIntensityHourly,
                                               temperatureHourly: temperatureHourly,
                                               temperatureApparentHourly: temperatureApparentHourly,
                                               uvIndexHourly: uvIndexHourly,
                                               visibilityHourly: visibilityHourly,
                                               windDirectionHourly: windDirectionHourly,
                                               windSpeedHourly: windSpeedHourly,
                                               conditionCodeDaily: conditionCodeDaily,
                                               maxUvIndexDaily: maxUvIndexDaily,
                                               precipitationAmountDaily: precipitationAmountDaily,
                                               precipitationChanceDaily: precipitationChanceDaily,
                                               precipitationTypeDaily: precipitationTypeDaily,
                                               snowfallAmountDaily: snowfallAmountDaily,
                                               sunriseDaily: sunriseDaily,
                                               sunsetDaily: sunsetDaily,
                                               temperatureMaxDaily: temperatureMaxDaily,
                                               temperatureMinDaily: temperatureMinDaily,
                                               forecastStartDaily: forecastStartDaily,
                                               cloudCoverDaily: cloudCoverDaily,
                                               humidityDaily: humidityDaily,
                                               windDirectionDaily: windDirectionDaily,
                                               windSpeedDaily: windSpeedDaily,
                                               weatherAlertDescription: weatherAlertDescription,
                                               weatherAlertImportance: weatherAlertImportance)

            return weatherData
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("There is an error with fetching all weather: \(key.stringValue) was not found. \(context.debugDescription)")
        } catch {
            print("Error parsing weather: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Fetch HourlyForecast
    func fetchHourlyForecast(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        
        let url = weatherKitURL + "/" + "\(lat)" + "/" + "\(long)"
        
        AF.request(url,
                   method: .get,
                   parameters: hourlyParameters,
                   headers: header).responseDecodable(of: HourlyForecastData.self) { response in
            if response.response?.statusCode == 401 {
                self.fetchHourlyForecast(lat, long)
            }
            guard let data = response.data else { return }
            if let weather = self.parseHourlyJSON(data) {
                self.weatherKitManagerDelegate?.didUpdateHourlyForecast(self, hourlyForecast: weather)
            }
        }
    }
    
    private func parseHourlyJSON(_ weatherData: Data) -> HourlyForecastModel? {
        do {
            let weather = try JSONDecoder().decode(HourlyForecastData.self, from: weatherData)
            
            let cloudCover = weather.nextHoursForecast.hourly.map { $0.cloudCover }
            let conditionCode = weather.nextHoursForecast.hourly.map { $0.conditionCode }
            let daylight = weather.nextHoursForecast.hourly.map { $0.daylight }
            let forecastStart = weather.nextHoursForecast.hourly.map { $0.forecastStart }
            let humidity = weather.nextHoursForecast.hourly.map { $0.humidity }
            let precipitationAmount = weather.nextHoursForecast.hourly.map { $0.precipitationAmount }
            let precipitationChance = weather.nextHoursForecast.hourly.map { $0.precipitationChance }
            let precipitationType = weather.nextHoursForecast.hourly.map { $0.precipitationType }
            let pressure = weather.nextHoursForecast.hourly.map { $0.pressure }
            let snowfallIntensity = weather.nextHoursForecast.hourly.map { $0.snowfallIntensity }
            let temperature = weather.nextHoursForecast.hourly.map { $0.temperature }
            let temperatureApparent = weather.nextHoursForecast.hourly.map { $0.temperatureApparent }
            let uvIndex = weather.nextHoursForecast.hourly.map { $0.uvIndex }
            let visibility = weather.nextHoursForecast.hourly.map { $0.visibility }
            let windDirection = weather.nextHoursForecast.hourly.map { $0.windDirection }
            let windSpeed = weather.nextHoursForecast.hourly.map { $0.windSpeed }
           
            let weatherData = HourlyForecastModel(cloudCover: cloudCover,
                                                  conditionCode: conditionCode,
                                                  daylight: daylight,
                                                  forecastStart: forecastStart,
                                                  humidity: humidity,
                                                  precipitationAmount: precipitationAmount,
                                                  precipitationChance: precipitationChance,
                                                  precipitationType: precipitationType,
                                                  pressure: pressure,
                                                  snowfallIntensity: snowfallIntensity,
                                                  temperature: temperature,
                                                  temperatureApparent: temperatureApparent,
                                                  uvIndex: uvIndex,
                                                  visibility: visibility,
                                                  windDirection: windDirection,
                                                  windSpeed: windSpeed)

            return weatherData
        } catch {
            print("Error parsing hourly forecast: \(error.localizedDescription)")
            return nil
        }
    }
}
