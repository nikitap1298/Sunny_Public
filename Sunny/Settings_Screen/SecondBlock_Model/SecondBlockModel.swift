//
//  SecondBlockModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.12.22.
//

import UIKit

struct SecondBlockModel {
    
    // Add L10nSettings.rateUsButtonText in the second update for AppSttore
    static let titleArray: [String] = [L10nSettings.appearanceButtonText,
                                       L10nSettings.subscribeButtonText,
                                       L10nSettings.rateUsButtonText,
                                       L10nSettings.aboutButtonText,
                                       L10nSettings.contactUsButtonText]
    
    // Add UIImages.like in the second update for AppSttore
    static let imageArray: [UIImage?] = [UIImages.iphone,
                                         UIImages.buy,
                                         UIImages.like,
                                         UIImages.info,
                                         UIImages.mail_3]
}
