//
//  Constants.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.07.2022.
//

import UIKit
import UIDeviceComplete
import UIDeviceComplete

// MARK: - Constraints
struct Constraints {
    
    static func contentViewTodayHeight() -> CGFloat {
        switch UIDevice.current.dc.deviceModel {
        case .iPhone15ProMax,
                .iPhone15Plus,
                .iPhone14ProMax,
                .iPhone14Plus,
                .iPhone13ProMax,
                .iPhone12ProMax,
                .iPhoneXSMax:
            return 1070
        case .iPhone11ProMax,
                .iPhone11Pro,
                .iPhone11,
                .iPhoneXR:
            return 1050
        case .iPhone15Pro,
                .iPhone15,
                .iPhone14Pro,
                .iPhone13Pro:
            return 1023
        case .iPhone13mini,
                .iPhone12mini,
                .iPhoneSE3,
                .iPhoneSE2,
                .iPhoneSE,
                .iPhone8,
                .iPhone7,
                .iPhone6S:
            return 1005
        case .iPhone8Plus,
                .iPhone7Plus,
                .iPhone6SPlus:
            return 995
        default:
            return 1000
        }
    }
    
    static func contentViewNextSevenDaysHeight() -> CGFloat {
        switch UIDevice.current.dc.deviceModel {
        case .iPhone15ProMax,
                .iPhone15Plus,
                .iPhone14ProMax,
                .iPhone14Plus,
                .iPhone13ProMax,
                .iPhone12ProMax,
                .iPhoneXSMax:
            return 725
        case .iPhone11ProMax,
                .iPhone11Pro,
                .iPhone11,
                .iPhoneXR:
            return 705
        case .iPhone13mini,
                .iPhone12mini,
                .iPhoneSE3,
                .iPhoneSE2,
                .iPhoneSE,
                .iPhone7,
                .iPhone6S:
            return 705
        default:
            return 673
        }
    }
    
    static let contentViewDetailedHeight: CGFloat = 1000
}

// MARK: - Ranges
struct Ranges {
    static let next24Hours: ClosedRange = 0...23
    static let next10Days: ClosedRange = 0...9
}

// MARK: - UserDefaultsKeys
struct UserDefaultsKeys {
    static let temperature = "TemperatureKey"
    static let speed = "SpeedKey"
    static let pressure = "PressureKey"
    static let precipitation = "PrecipitationKey"
    static let distance = "DistanceKey"
    static let timeFormat = "TimeFormatKey"
    
    static let isCurrent = "IsCurrentKey"
    static let currentLocationLatitude = "CurrentLocationLatitudeKey"
    static let currentLocationLongitude = "CurrentLocationLongitudeKey"
    static let cityLatitude = "CityLatitudeKey"
    static let cityLongitude = "CityLongitudeKey"
    static let onboardingVCAddress = "OnboardingVCAddress"
    
    static let lightMode = "LightMode"
    static let darkMode = "DarkMode"
    static let systemMode = "SystemMode"
    
    static let lightKey = "LightKey"
    static let darkKey = "DarkKey"
    static let systemKey = "SystemKey"
    
    static let temperatureButtonChange = "TemperatureButtonChange"
    static let allowUpdateDBUsingWeatherKit = "AllowUpdateDBUsingWeatherKit"
    
    static let initialLaunch = "InitialLaunchKey"
    
    static let allowNotifications = "AllowNotificationsKey"
    static let currentNotificationTime = "CurrentNotificationTimeKey"
}

// MARK: - NotificationNames
struct NotificationNames {
    static let updateLocation = Notification.Name("UpdateLocationNotification")
    
    static let lightMode = Notification.Name("LightModeNotification")
    static let darkMode = Notification.Name("DarkModeNotification")
    static let systemMode = Notification.Name("SystemModeNotification")
    
    static let temperatureButtonPressed = Notification.Name("TemperatureButtonNotification")
}


