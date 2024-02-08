//
//  AboutButtonsModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.12.22.
//

import UIKit

struct AboutButtonsModel {
    
    let titleArray: [String] = [L10nSettings.developerLabelText,
                                L10nSettings.versionLabelText,
                                L10nSettings.illustrationsLabelText,
                                L10nSettings.illustrationsLabelText,
                                L10nSettings.termsOfUseLabelText,
                                L10nSettings.privacyPolicyLabelText]
    
    let textArray: [String] = ["Nikita P.",
                               UIApplication.appVersion ?? "-",
                               "flaticon",
                               "icons8",
                               "",
                               ""]
    let imageArray: [UIImage?] = [UIImages.link,
                                  UIImages.build,
                                  UIImages.certificate,
                                  UIImages.certificate,
                                  UIImages.agreement,
                                  UIImages.agreement]
}
