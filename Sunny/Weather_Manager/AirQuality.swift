//
//  AirQuality.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 08.06.23.
//

import UIKit

struct AirQuality {
    
    func description(_ aqi: Int) -> String? {
        switch aqi {
        case 1:
            return L10nAirPollution.goodTextText
        case 2:
            return L10nAirPollution.fairTextText
        case 3:
            return L10nAirPollution.moderateTextText
        case 4:
            return L10nAirPollution.poorTextText
        case 5:
            return L10nAirPollution.veryPoorTextText
        default:
            return "-"
        }
    }
    
    func icon(_ aqi: Int) -> UIImage? {
        switch aqi {
        case 1:
            return AirPollutionImages.goodAQI
        case 2:
            return AirPollutionImages.goodAQI
        case 3:
            return AirPollutionImages.moderateAQI
        case 4:
            return AirPollutionImages.poorAQI
        case 5:
            return AirPollutionImages.veryPoorAQI
        default:
            return AirPollutionImages.goodAQI
        }
    }
}
