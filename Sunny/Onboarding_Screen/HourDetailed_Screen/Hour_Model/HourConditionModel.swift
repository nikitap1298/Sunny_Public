//
//  DetailedConditionModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 28.08.2022.
//

import UIKit

struct HourConditionModel {
    
    private let converter = Converter()
    private let timeConverter = TimeConverter()
    private let clothesType = ClothesType()
    private let windDirection = WindDirection()
    private let uvIndex = UVIndex()
    
    let parameterNameArray: [String] = [L10nCondititionDescription.feelsLikeLabelText,
                                        L10nCondititionDescription.precipitationLabelText,
                                        L10nCondititionDescription.clothesLabelText,
                                        L10nCondititionDescription.pressureLabelText,
                                        L10nCondititionDescription.humidityLabelText,
                                        L10nCondititionDescription.windLabelText,
                                        L10nCondititionDescription.cloudCoverLabelText,
                                        L10nCondititionDescription.uvIndexLabelText]
    
    var parameterImageArray: [UIImage?] = [ConditionImages.pressure,
                                           ConditionImages.humidity,
                                           ConditionImages.cloud]
    var parameterValueArray: [String] = []
    
    mutating func fillImageArray(data: HourlyForecastModel, currentIndex: Int) {
        if data.temperatureApparent[currentIndex] >= 0.1 {
            parameterImageArray.insert(ConditionImages.thermometerHot, at: 0)
        } else {
            parameterImageArray.insert(ConditionImages.thermometerCold, at: 0)
        }
        
        if data.precipitationAmount[currentIndex] == 0.0 {
            parameterImageArray.insert(ConditionImages.umbrella, at: 1)
        } else {
            switch data.precipitationType[currentIndex] {
            case "clear":
                parameterImageArray.insert(ConditionImages.umbrella, at: 1)
            case "precipitation":
                parameterImageArray.insert(ConditionImages.umbrella, at: 1)
            case "rain":
                parameterImageArray.insert(ConditionImages.rainfall, at: 1)
            case "snow":
                parameterImageArray.insert(ConditionImages.snowfall, at: 1)
            case "sleet":
                parameterImageArray.insert(ConditionImages.snowfall, at: 1)
            case "hail":
                parameterImageArray.insert(ConditionImages.hail, at: 1)
            case "mixed":
                parameterImageArray.insert(ConditionImages.snowfall, at: 1)
            default:
                fatalError("Unexpected precipitationType: \(data.precipitationType[currentIndex])")
            }
        }
        parameterImageArray.insert(clothesType.image(data.temperatureApparent[currentIndex], data.windSpeed[currentIndex]), at: 2)
        parameterImageArray.insert(windDirection.degreeImage(data.windDirection[currentIndex]), at: 5)
        parameterImageArray.insert(uvIndex.icon(data.uvIndex[currentIndex]), at: 7)
    }
    
    mutating func fillValueArray(data: HourlyForecastModel, currentIndex: Int) {
        parameterValueArray.append(converter.convertTemperature(data.temperatureApparent[currentIndex]))
        parameterValueArray.append(converter.convertPrecipitation(data.precipitationAmount[currentIndex]))
        parameterValueArray.append(clothesType.description(data.temperatureApparent[currentIndex], data.windSpeed[currentIndex]))
        parameterValueArray.append(converter.convertPressure(data.pressure[currentIndex]))
        parameterValueArray.append("\(Int(data.humidity[currentIndex] * 100)) %")
        parameterValueArray.append(converter.convertSpeed(data.windSpeed[currentIndex]))
        parameterValueArray.append("\(Int(data.cloudCover[currentIndex] * 100)) %")
        parameterValueArray.append("\(data.uvIndex[currentIndex])")
    }
}
