//
//  DayConditionModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 15.11.2022.
//

import UIKit

struct DayConditionModel {
    
    private let converter = Converter()
    private let timeConverter = TimeConverter()
    private let clothesType = ClothesType()
    private let windDirection = WindDirection()
    private let uvIndex = UVIndex()
    
    var parameterNameArray = [String]()
    
    var parameterImageArray = [UIImage?]()
    var parameterValueArray = [String]()
    
    mutating func fillNameArray(data: AllWeatherModels, currentIndex: Int) {
        
        /*
         If data.sunriseDaily or data.sunsetDaily contains nil, then element will not be added inside the array.
         For example if now is polar night then place doesn't have sunset & sunrise
        */
        if !data.sunriseDaily.contains(nil) || !data.sunsetDaily.contains(nil) {
            parameterNameArray.append(L10nCondititionDescription.sunriseLabelText)
            parameterNameArray.append(L10nCondititionDescription.sunsetLabelText)
        }
        
        parameterNameArray.append(L10nCondititionDescription.falloutChanceLabelText)
        parameterNameArray.append(L10nCondititionDescription.clothesLabelText)
        parameterNameArray.append(L10nCondititionDescription.humidityLabelText)
        parameterNameArray.append(L10nCondititionDescription.windLabelText)
        parameterNameArray.append(L10nCondititionDescription.cloudCoverLabelText)
        parameterNameArray.append(L10nCondititionDescription.uvIndexLabelText)
    }
    
    mutating func fillImageArray(data: AllWeatherModels, currentIndex: Int) {
        
        /*
         If data.sunriseDaily or data.sunsetDaily contains nil, then element will not be added inside the array.
         For example if now is polar night then place doesn't have sunset & sunrise
        */
        if !data.sunriseDaily.contains(nil) || !data.sunsetDaily.contains(nil) {
            parameterImageArray.append(ConditionImages.sunrise)
            parameterImageArray.append(ConditionImages.sunset)
        }
        
        if data.precipitationChanceDaily[currentIndex] > 0.0 {
            switch data.precipitationTypeDaily[currentIndex] {
            case "clear":
                parameterImageArray.append(ConditionImages.umbrella)
            case "precipitation":
                parameterImageArray.append(ConditionImages.umbrella)
            case "rain":
                parameterImageArray.append(ConditionImages.rainfall)
            case "snow":
                parameterImageArray.append(ConditionImages.snowfall)
            case "sleet":
                parameterImageArray.append(ConditionImages.snowfall)
            case "hail":
                parameterImageArray.append(ConditionImages.hail)
            case "mixed":
                parameterImageArray.append(ConditionImages.rainfall)
            case "":
                parameterImageArray.append(ConditionImages.umbrella)
            default:
                fatalError("Unexpected precipitationTypeDaily: \(data.precipitationTypeDaily[currentIndex])")
            }
        } else {
            parameterImageArray.append(ConditionImages.umbrella)
        }
        parameterImageArray.append(clothesType.image(data.temperatureMaxDaily[currentIndex], data.windSpeedDaily[currentIndex]))
        parameterImageArray.append(ConditionImages.humidity)
        parameterImageArray.append(windDirection.degreeImage(data.windDirectionDaily[currentIndex]))
        parameterImageArray.append(ConditionImages.cloud)
        parameterImageArray.append(uvIndex.icon(data.maxUvIndexDaily[currentIndex]))
    }
    
    mutating func fillValueArray(data: AllWeatherModels, currentIndex: Int, timeZone: Int) {
        
        /*
         If data.sunriseDaily or data.sunsetDaily contains nil, then element will not be added inside the array.
         For example if now is polar night then place doesn't have sunset & sunrise
        */
        if !data.sunriseDaily.contains(nil) || !data.sunsetDaily.contains(nil) {
            parameterValueArray.append(timeConverter.convertToHoursMinutes(data.sunriseDaily[currentIndex] ?? "", timeZone) ?? "")
            parameterValueArray.append(timeConverter.convertToHoursMinutes(data.sunsetDaily[currentIndex] ?? "", timeZone) ?? "")
        }
        parameterValueArray.append("\(Int(data.precipitationChanceDaily[currentIndex] * 100)) %")
        parameterValueArray.append(clothesType.description(data.temperatureMaxDaily[currentIndex], data.windSpeedDaily[currentIndex]))
        parameterValueArray.append("\(Int(data.humidityDaily[currentIndex] * 100)) %")
        parameterValueArray.append(converter.convertSpeed(data.windSpeedDaily[currentIndex]))
        parameterValueArray.append("\(Int(data.cloudCoverDaily[currentIndex] * 100)) %")
        parameterValueArray.append("\(data.maxUvIndexDaily[currentIndex])")
    }
}
