//
//  L10n.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 01.12.2022.
//

import UIKit

// MARK: - L10nSettings
struct L10nSettings {
    
    // Settings Screen
    static let settingsNavText = "settingsNavTitleKey".localized
    
    static let temperatureButtonText = "temperatureButtonKey".localized
    
    static let speedButtonText = "speedButtonKey".localized
    static let speedButtonLeftValueText = "speedButtonLeftValueKey".localized
    static let speedButtonRightValueText = "speedButtonRightValueKey".localized
    
    static let pressureButtonText = "pressureButtonKey".localized
    static let pressureButtonLeftValueText = "pressureButtonLeftValueKey".localized
    static let pressureButtonRightValueText = "pressureButtonRightValueKey".localized
    
    static let precipitationButtonText = "precipitationButtonKey".localized
    static let precipitationButtonLeftValueText = "precipitationButtonLeftValueKey".localized
    static let precipitationButtonRightValueText = "precipitationButtonRightValueKey".localized
    
    static let distanceButtonText = "distanceButtonKey".localized
    static let distanceButtonLeftValueText = "distanceButtonLeftValueKey".localized
    static let distanceButtonRightValueText = "distanceButtonRightValueKey".localized
    
    static let timeFormatButtonText = "timeFormatButtonKey".localized
    static let timeFormatButtonLeftValueText = "timeFormatButtonLeftValueKey".localized
    static let timeFormatButtonRightValueText = "timeFormatButtonRightValueKey".localized
    
    static let appearanceButtonText = "appearanceButtonKey".localized
    static let notificationButtonText = "notificationButtonKey".localized
    static let subscribeButtonText = "subscribeButtonKey".localized
    static let aboutButtonText = "aboutButtonKey".localized
    static let rateUsButtonText = "rateUsButtonKey".localized
    static let contactUsButtonText = "contactUsButtonKey".localized
    
    // Appearance Screen
    static let appearanceNavText = "appearanceNavTitleKey".localized
    static let lightLabelText = "lightLabelKey".localized
    static let darkLabelText = "darkLabelKey".localized
    static let systemLabelText = "systemLabelKey".localized
    
    // About Screen
    static let aboutNavText = "aboutNavTitleKey".localized
    static let developerLabelText = "developerLabelKey".localized
    static let versionLabelText = "versionLabelKey".localized
    static let illustrationsLabelText = "illustrationsLabelKey".localized
    static let termsOfUseLabelText = "termsOfUseLabelKey".localized
    static let privacyPolicyLabelText = "privacyPolicyLabelKey".localized
    
    // Subscription Screen
    static let subscriptionNavTitle = "subscriptionNavTitleKey".localized
    static let subscriptionHeaderLabel = "subscriptionHeaderLabelKey".localized
    static let subscriptionDescriptionLabel = "subscriptionDescriptionLabelKey".localized
    static let subscriptionMonthlyButtonType1 = "subscriptionMonthlyButtonType1Key".localized
    static let subscriptionMonthlyButtonType2 = "subscriptionMonthlyButtonType2Key".localized
    static let subscriptionOneWeekTrialLabel = "subscriptionOneWeekTrialLabelKey".localized
    static let subscriptionRestorePurchasesButton = "subscriptionRestorePurchasesButtonKey".localized
    static let subscriptionAlertActionTitle = "subscriptionAlertActionTitleKey".localized
    static let subscriptionAlertSuccessfulTitle = "subscriptionAlertSuccessfulTitleKey".localized
    static let subscriptionAlertSuccessfulMessage = "subscriptionAlertSuccessfulMessageKey".localized
    static let subscriptionAlertFailedTitle = "subscriptionAlertFailedTitleKey".localized
    static let subscriptionAlertFailedMessage = "subscriptionAlertFailedMessageKey".localized
}

// MARK: - L10nSearch
struct L10nSearch {
    static let searchNavText = "searchNavTitleKey".localized
    static let seacrhPlaceholderText = "searchTextFieldPlaceholderKey".localized
    static let cancelButtonText = "cancelButtonKey".localized
    static let addedCityText = "addedCityTextKey".localized
    static let limitReachedText = "limitReachedTextKey".localized
    static let currentLocationCell = "currentLocationCellKey".localized
    static let placeNotFoundTitle = "placeNotFoundTitleKey".localized
    
    static let coordinatesAlertTitle = "coordinatesAlertTitleKey".localized
    static let coordinatesAlertLatitude = "coordinatesAlertLatitudeKey".localized
    static let coordinatesAlertLongitude = "coordinatesAlertLongitudeKey".localized
    static let coordinatesAlertOk = "coordinatesAlertOkKey".localized
    static let coordinatesAlertCancel = "coordinatesAlertCancelKey".localized
}

// MARK: - L10nCondititionDescription
struct L10nCondititionDescription {
    static let feelsLikeLabelText = "feelsLikeTextKey".localized
    static let precipitationLabelText = "precipitationTextKey".localized
    static let clothesLabelText = "clothesTextKey".localized
    static let pressureLabelText = "pressureTextKey".localized
    static let humidityLabelText = "humidityTextKey".localized
    static let visibilityLabelText = "visibilityTextKey".localized
    static let windLabelText = "windTextKey".localized
    static let cloudCoverLabelText = "cloudCoverTextKey".localized
    static let uvIndexLabelText = "uvIndexTextKey".localized
    static let airQualityLabelText = "airQualityTextKey".localized
    static let sunriseLabelText = "sunriseTextKey".localized
    static let sunsetLabelText = "sunsetTextKey".localized
    static let falloutChanceLabelText = "falloutChanceTextKey".localized
}

// MARK: - L10nGraph
struct L10nGraph {
    static let onboardingVCGraphText = "onboardingVCGraphTextKey".localized
    static let dayVCGraphText = "dayVCGraphTextKey".localized
}

// MARK: - L10nOnboarding
struct L10nOnboarding {
    static let onboardingNavText = "onboardingNavTitleKey".localized
    static let cityLabelText = "cityLabelKey".localized
    static let descriptionLabelText = "descriptionLabelKey".localized
    static let todayButtonText = "todayButtonKey".localized
    static let next10DaysButtonText = "next10DaysButtonKey".localized
}

// MARK: - L10nClothesDescription
struct L10nClothesDescription {
    static let tShirtText = "tShirtTextKey".localized
    static let shirtText = "shirtTextKey".localized
    static let hoodieText = "hoodieTextKey".localized
    static let jacketText = "jacketTextKey".localized
    static let warmJacketText = "warmJacketTextKey".localized
}

// MARK: - L10nAirPollution
struct L10nAirPollution {
    static let goodTextText = "goodTextKey".localized
    static let fairTextText = "fairTextKey".localized
    static let moderateTextText = "moderateTextKey".localized
    static let poorTextText = "poorTextKey".localized
    static let veryPoorTextText = "veryPoorTextKey".localized
}

// MARK: - L10nWeatherDescription
struct L10nWeatherDescription {
    static let clearText = "clearTextKey".localized
    static let cloudyText = "cloudyTextKey".localized
    static let dustText = "dustTextKey".localized
    static let fogText = "fogTextKey".localized
    static let hazeText = "hazeTextKey".localized
    static let mostlyClearText = "mostlyClearTextKey".localized
    static let mostlyCloudyText = "mostlyCloudyTextKey".localized
    static let partlyCloudyText = "partlyCloudyTextKey".localized
    static let scatteredThunderstormsText = "scatteredThunderstormsTextKey".localized
    static let smokeText = "smokeTextKey".localized
    static let breezyText = "breezyTextKey".localized
    static let windyText = "windyTextKey".localized
    static let drizzleText = "drizzleTextKey".localized
    static let heavyRainText = "heavyRainTextKey".localized
    static let rainText = "rainTextKey".localized
    static let showersText = "showersTextKey".localized
    static let flurriesText = "flurriesTextKey".localized
    static let heavySnowText = "heavySnowTextKey".localized
    static let mixedRainAndSleetText = "mixedRainAndSleetTextKey".localized
    static let mixedRainAndSnowText = "mixedRainAndSnowTextKey".localized
    static let mixedRainfallText = "mixedRainfallTextKey".localized
    static let mixedSnowAndSleetText = "mixedSnowAndSleetTextKey".localized
    static let scatteredShowersText = "scatteredShowersTextKey".localized
    static let scatteredSnowShowersText = "scatteredSnowShowersTextKey".localized
    static let sleetText = "sleetTextKey".localized
    static let snowText = "snowTextKey".localized
    static let snowShowersText = "snowShowersTextKey".localized
    static let blizzardText = "blizzardTextKey".localized
    static let blowingSnowText = "blowingSnowTextKey".localized
    static let freezingDrizzleText = "freezingDrizzleTextKey".localized
    static let freezingRainText = "freezingRainTextKey".localized
    static let frigidText = "frigidTextKey".localized
    static let hailText = "hailTextKey".localized
    static let hotText = "hotTextKey".localized
    static let hurricaneText = "hurricaneTextKey".localized
    static let isolatedThunderstormsText = "isolatedThunderstormsTextKey".localized
    static let severeThunderstormText = "severeThunderstormTextKey".localized
    static let thunderstormText = "thunderstormTextKey".localized
    static let tornadoText = "tornadoTextKey".localized
    static let tropicalStormText = "tropicalStormTextKey".localized
}

// MARK: - L10nNoInternet
struct L10nNoInternet {
    static let weatherUnavailableLabelText = "weatherUnavailableLabelKey".localized
    static let noInternetLabelText = "noInternetLabelKey".localized
    static let goToSettingsButtonText = "goToSettingsButtonKey".localized
}

// MARK: - L10nMailField
struct L10nMailField {
    static let mailTemplateFirstSentenseText = "mailTemplateFirstSentenseTextKey".localized
    static let mailTemplateSecondSentenseText = "mailTemplateSecondSentenseTextKey".localized
    static let mailTemplateSunnyVersionText = "mailTemplateSunnyVersionTextKey".localized
    static let mailTemplateSunnyVersionOptionalText = "mailTemplateSunnyVersionOptionalTextKey".localized
    static let mailTemplateIOSVersionText = "mailTemplateIOSVersionTextKey".localized
    static let mailTemplateDeviceModelVersionText = "mailTemplateDeviceModelVersionTextKey".localized
}

// MARK: - L10nTutorial
struct L10nTutorial {
    static let tutorialTitle0 = "tutorialTitle0Key".localized
    static let tutorialTitle1 = "tutorialTitle1Key".localized
    static let tutorialTitle2 = "tutorialTitle2Key".localized
    static let tutorialTitle3 = "tutorialTitle3Key".localized
    static let tutorialTitle4 = "tutorialTitle4Key".localized
    static let tutorialTitle5 = "tutorialTitle5Key".localized
    static let tutorialTitle6 = "tutorialTitle6Key".localized

    static let tutorialText0 = "tutorialText0Key".localized
    static let tutorialText1 = "tutorialText1Key".localized
    static let tutorialText2 = "tutorialText2Key".localized
    static let tutorialText3 = "tutorialText3Key".localized
    static let tutorialText4 = "tutorialText4Key".localized
    static let tutorialText5 = "tutorialText5Key".localized
    static let tutorialText6 = "tutorialText6Key".localized
     
    static let tutorialButton0 = "tutorialButton0Key".localized
    static let tutorialButton1 = "tutorialButton1Key".localized
    static let tutorialButton2 = "tutorialButton2Key".localized
    static let tutorialButton3 = "tutorialButton3Key".localized
    static let tutorialButton4 = "tutorialButton4Key".localized
    static let tutorialButton5 = "tutorialButton5Key".localized
    static let tutorialButton6 = "tutorialButton6Key".localized
}

// MARK: - L10Map
struct L10nMap {
    static let mapNavTitleText = "mapNavTitleKey".localized
    static let mapTypeHybrid = "mapTypeHybridKey".localized
    static let mapTypeSatellite = "mapTypeSatelliteKey".localized
    static let mapTypeMutedStandart = "mapTypeMutedStandartKey".localized
    static let mapTypeStandart = "mapTypeStandartKey".localized
}
