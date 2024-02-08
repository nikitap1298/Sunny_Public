//
//  OpenWeatherManager.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 22.12.22.
//

import UIKit
import Alamofire
import CoreLocation

protocol OpenWeatherManagerDelegate: AnyObject {
    func didUpdateCurrentAirPollution(_ openWeatherManager: OpenWeatherManager, currentAirPollution: CurrentAirPollutionModel)
}

extension OpenWeatherManagerDelegate {
    func didUpdateCurrentAirPollution(_ openWeatherManager: OpenWeatherManager, currentAirPollution: CurrentAirPollutionModel) { }
}

// MARK: - OpenWeatherManager
struct OpenWeatherManager {
    
    private let openWeatherAirPollutionURL = "https://api.openweathermap.org/data/2.5/air_pollution?"
    private let apiKey = ""
    
    weak var openWeatherManagerDelegate: OpenWeatherManagerDelegate?
    
    // MARK: - Fetch CurrentAirPollution
    func fetchCurrentAirPollution(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        
        var allParameters: Parameters = ["lat": "",
                                         "lon": "",
                                         "appid": apiKey,
                                         "units": "metric"]
        
        allParameters["lat"] = String(lat)
        allParameters["lon"] = String(long)
        
        AF.request(openWeatherAirPollutionURL,
                   method: .get,
                   parameters: allParameters).responseDecodable(of: CurrentAirPollutionData.self) { response in
            guard let data = response.data else { return }
            if let weather = self.parseCurrentAirPollutionJSON(data) {
                self.openWeatherManagerDelegate?.didUpdateCurrentAirPollution(self, currentAirPollution: weather)
            }
        }
    }
    
    private func parseCurrentAirPollutionJSON(_ weatherData: Data) -> CurrentAirPollutionModel? {
        do {
            let weather = try JSONDecoder().decode(CurrentAirPollutionData.self, from: weatherData)
            
            let aqi = weather.airList.map { $0.main.aqi }
            let co = weather.airList.map { $0.airComponents.co }
            let no = weather.airList.map { $0.airComponents.no }
            let no2 = weather.airList.map { $0.airComponents.no2 }
            let o3 = weather.airList.map { $0.airComponents.o3 }
            let so2 = weather.airList.map { $0.airComponents.so2 }
            
            let weatherData = CurrentAirPollutionModel(aqi: aqi,
                                                       co: co,
                                                       no: no,
                                                       no2: no2,
                                                       o3: o3,
                                                       so2: so2)
            
            return weatherData
        } catch DecodingError.keyNotFound(let key, let context) {
            print("There is an error with fetching current air pollution: \(key.stringValue) was not found. \(context.debugDescription)")
//            fatalError("There is an error with fetching current air pollution: \(key.stringValue) was not found. \(context.debugDescription)")
            return nil
        } catch {
            print("Error parsing current air pollution: \(error.localizedDescription)")
            return nil
        }
    }
}
