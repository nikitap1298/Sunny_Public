//
//  WeatherDescription.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 09.09.2022.
//

import UIKit

struct WeatherDescription {
    
    func condition(_ conditionCode: String) -> String? {
        switch conditionCode {
        case "Clear":
            return L10nWeatherDescription.clearText
        case "Cloudy":
            return L10nWeatherDescription.cloudyText
        case "Dust":
            return L10nWeatherDescription.dustText
        case "Foggy":
            return L10nWeatherDescription.fogText
        case "Haze":
            return L10nWeatherDescription.hazeText
        case "MostlyClear":
            return L10nWeatherDescription.mostlyClearText
        case "MostlyCloudy":
            return L10nWeatherDescription.mostlyCloudyText
        case "PartlyCloudy":
            return L10nWeatherDescription.partlyCloudyText
        case "ScatteredThunderstorms":
            return L10nWeatherDescription.scatteredThunderstormsText
        case "Smoke":
            return L10nWeatherDescription.smokeText
        case "Breezy":
            return L10nWeatherDescription.breezyText
        case "Windy":
            return L10nWeatherDescription.windyText
        case "Drizzle":
            return L10nWeatherDescription.drizzleText
        case "HeavyRain":
            return L10nWeatherDescription.heavyRainText
        case "Rain":
            return L10nWeatherDescription.rainText
        case "Showers":
            return L10nWeatherDescription.showersText
        case "Flurries":
            return L10nWeatherDescription.flurriesText
        case "HeavySnow":
            return L10nWeatherDescription.heavySnowText
        case "MixedRainAndSleet":
            return L10nWeatherDescription.mixedRainAndSleetText
        case "MixedRainAndSnow":
            return L10nWeatherDescription.mixedRainAndSnowText
        case "MixedRainfall":
            return L10nWeatherDescription.mixedRainfallText
        case "MixedSnowAndSleet":
            return L10nWeatherDescription.mixedSnowAndSleetText
        case "ScatteredShowers":
            return L10nWeatherDescription.scatteredShowersText
        case "ScatteredSnowShowers":
            return L10nWeatherDescription.scatteredSnowShowersText
        case "Sleet":
            return L10nWeatherDescription.sleetText
        case "Snow":
            return L10nWeatherDescription.snowText
        case "SnowShowers":
            return L10nWeatherDescription.snowShowersText
        case "Blizzard":
            return L10nWeatherDescription.blizzardText
        case "BlowingSnow":
            return L10nWeatherDescription.blowingSnowText
        case "FreezingDrizzle":
            return L10nWeatherDescription.freezingDrizzleText
        case "FreezingRain":
            return L10nWeatherDescription.freezingRainText
        case "Frigid":
            return L10nWeatherDescription.frigidText
        case "Hail":
            return L10nWeatherDescription.hailText
        case "Hot":
            return L10nWeatherDescription.hotText
        case "Hurricane":
            return L10nWeatherDescription.hurricaneText
        case "IsolatedThunderstorms":
            return L10nWeatherDescription.isolatedThunderstormsText
        case "SevereThunderstorm":
            return L10nWeatherDescription.severeThunderstormText
        case "Thunderstorms":
            return L10nWeatherDescription.thunderstormText
        case "Tornado":
            return L10nWeatherDescription.tornadoText
        case "TropicalStorm":
            return L10nWeatherDescription.tropicalStormText
        case "Launch":
            return L10nOnboarding.descriptionLabelText
        default:
            fatalError("Unexpected weather condition code: \(conditionCode)")
        }
    }
}

//Clear
//Cloudy
//Dust
//Fog
//Haze
//MostlyClear
//MostlyCloudy
//PartlyCloudy
//ScatteredThunderstorms
//Smoke
//Breezy
//Windy
//Drizzle
//HeavyRain
//Rain
//Showers
//Flurries
//HeavySnow
//MixedRainAndSleet
//MixedRainAndSnow
//MixedRainfall
//MixedSnowAndSleet
//ScatteredShowers
//ScatteredSnowShowers
//Sleet
//Snow
//SnowShowers
//Blizzard
//BlowingSnow
//FreezingDrizzle
//FreezingRain
//Frigid
//Hail
//Hot
//Hurricane
//IsolatedThunderstorms
//SevereThunderstorm
//Thunderstorm
//Tornado
//TropicalStorm
