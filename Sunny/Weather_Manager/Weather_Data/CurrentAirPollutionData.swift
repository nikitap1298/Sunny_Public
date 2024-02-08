//
//  CurrentAirPollutionData.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 22.12.22.
//

import UIKit

// MARK: - CurrentAirPollutionData
struct CurrentAirPollutionData: Decodable {
    let airList: [AirList]
    
    enum CodingKeys: String, CodingKey {
        case airList = "list"
    }
}

struct AirList: Decodable {
    let main: Main
    let airComponents: AirComponents
    
    enum CodingKeys: String, CodingKey {
        case main
        case airComponents = "components"
    }
}

struct Main: Decodable {
    let aqi: Int
}

struct AirComponents: Decodable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
}

// MARK: - CurrentAirPollutionModel
struct CurrentAirPollutionModel {
    var aqi: [Int] = [0]
    var co: [Double] = [0.0]
    var no: [Double] = [0.0]
    var no2: [Double] = [0.0]
    var o3: [Double] = [0.0]
    var so2: [Double] = [0.0]
}
