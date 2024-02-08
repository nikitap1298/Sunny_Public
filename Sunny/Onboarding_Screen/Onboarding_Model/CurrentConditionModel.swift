//
//  CurrentConditionalModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 09.09.2022.
//

import UIKit

struct CurrentConditionModel {
    
    private let weatherDescription = WeatherDescription()
    private let conditionImage = ConditionImage()
    private let windDirection = WindDirection()
    private let uvIndex = UVIndex()
    private let clothesType = ClothesType()
    private let airQuality = AirQuality()
    
    let parameterNameArray: [String] = [L10nCondititionDescription.feelsLikeLabelText,
                                        L10nCondititionDescription.precipitationLabelText,
                                        L10nCondititionDescription.clothesLabelText,
                                        L10nCondititionDescription.pressureLabelText,
                                        L10nCondititionDescription.humidityLabelText,
                                        L10nCondititionDescription.visibilityLabelText,
                                        L10nCondititionDescription.windLabelText,
                                        L10nCondititionDescription.cloudCoverLabelText,
                                        L10nCondititionDescription.uvIndexLabelText,
                                        L10nCondititionDescription.airQualityLabelText]
    
    var parameterValueArray: [String] = []
    
    var parameterImageArray: [UIImage?] = []
    
    mutating func fillValueArray(_ allData: AllWeatherModels?,
                                 _ converter: Converter?,
                                 _ airPollution: CurrentAirPollutionModel?) {
        
        guard let allData = allData,
              let converter = converter,
              let airPollution = airPollution else { return }
        
        parameterValueArray.append(converter.convertTemperature(allData.temperatureApparentCurrent))
        parameterValueArray.append(converter.convertPrecipitation(allData.precipitationIntensityCurrent))
        parameterValueArray.append(clothesType.description(allData.temperatureApparentCurrent, allData.windSpeedCurrent))
        parameterValueArray.append(converter.convertPressure(allData.pressureCurrent))
        parameterValueArray.append("\(Int(allData.humidityCurrent * 100)) %")
        parameterValueArray.append(converter.convertKmToMil(allData.visibilityCurrent))
        parameterValueArray.append(converter.convertSpeed(allData.windSpeedCurrent))
        parameterValueArray.append("\(Int(allData.cloudCoverCurrent * 100)) %")
        parameterValueArray.append("\(allData.uvIndexCurrent)")
        parameterValueArray.append(airQuality.description(airPollution.aqi[0]) ?? "Good")
    }
    
    mutating func fillImageArray(_ allData: AllWeatherModels?,
                                 _ hourlyData: HourlyForecastModel?,
                                 _ airPollution: CurrentAirPollutionModel?) {
        
        guard let allData = allData,
              let hourlyData = hourlyData,
              let airPollution = airPollution else { return }
        
        if allData.temperatureApparentCurrent >= 0.1 {
            parameterImageArray.append(ConditionImages.thermometerHot)
        } else {
            parameterImageArray.append(ConditionImages.thermometerCold)
        }
        
        if allData.precipitationIntensityCurrent == 0.0 {
            parameterImageArray.append( ConditionImages.umbrella)
        } else {
            switch hourlyData.precipitationType[0] {
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
                parameterImageArray.append(ConditionImages.snowfall)
            case "":
                parameterImageArray.append(ConditionImages.rainfall)
            default:
                fatalError("Unexpected hourly precipitationType : \(hourlyData.precipitationType[0]))")
            }
        }
        
        parameterImageArray.append(clothesType.image(allData.temperatureApparentCurrent, allData.windSpeedCurrent))
        parameterImageArray.append(ConditionImages.pressure)
        parameterImageArray.append(ConditionImages.humidity)
        parameterImageArray.append(ConditionImages.visibility)
        parameterImageArray.append(windDirection.degreeImage(allData.windDirectionCurrent))
        parameterImageArray.append(ConditionImages.cloud)
        parameterImageArray.append(uvIndex.icon(allData.uvIndexCurrent))
        parameterImageArray.append(airQuality.icon(airPollution.aqi[0]))
    }
    
    func fillView(_ current: CurrentWeatherView?,
                  _ allData: AllWeatherModels?,
                  _ converter: Converter?,
                  _ timeConverter: TimeConverter?,
                  _ timeZone: Int?) {
        
        guard let current = current,
              let allData = allData,
              let converter = converter,
              let timeConverter = timeConverter else { return }
        
        current.dateLabel.text = timeConverter.convertToDayMonthNumber(allData.asOfCurrent, timeZone: timeZone)
        
        if allData.temperatureCurrent == nil {
            current.temperatureLabel.text = "-   -"
        } else {
            current.temperatureLabel.text = converter.convertTemperature(allData.temperatureCurrent ?? 0.0)
        }
//        current.temperatureLabel.text = converter.convertTemperature(data.temperature ?? 0.0)
        current.temperatureImage.image = conditionImage.weatherIcon(allData.conditionCodeCurrent, allData.daylightCurrent)
        current.descriptionLabel.text = weatherDescription.condition(allData.conditionCodeCurrent)
        
        if current.descriptionLabel.text?.count ?? 0 > 16 {
            current.descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 12)
        } else {
            current.descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        }
    }
}
