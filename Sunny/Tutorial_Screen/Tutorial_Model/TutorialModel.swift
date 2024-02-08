//
//  TutorialModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 11.12.22.
//

import UIKit

struct TutorialModel {
    
    var imageArray: [UIImage?] = [nil,
                                  TutorialImages.weatherScreen,
                                  TutorialImages.hourlyScreen,
                                  TutorialImages.dailyScreen,
                                  TutorialImages.searchScreen,
                                  TutorialImages.settingsScreen,
                                  TutorialImages.importantScreen]
    
    var titleArray: [String] = [L10nTutorial.tutorialTitle0,
                                L10nTutorial.tutorialTitle1,
                                L10nTutorial.tutorialTitle2,
                                L10nTutorial.tutorialTitle3,
                                L10nTutorial.tutorialTitle4,
                                L10nTutorial.tutorialTitle5,
                                L10nTutorial.tutorialTitle6]
    
    var textArray: [String] = ["",
                               L10nTutorial.tutorialText1,
                               L10nTutorial.tutorialText2,
                               L10nTutorial.tutorialText3,
                               L10nTutorial.tutorialText4,
                               L10nTutorial.tutorialText5,
                               L10nTutorial.tutorialText6]
    
    var buttonText: [String] = [L10nTutorial.tutorialButton1,
                                L10nTutorial.tutorialButton2,
                                L10nTutorial.tutorialButton3,
                                L10nTutorial.tutorialButton4,
                                L10nTutorial.tutorialButton5,
                                L10nTutorial.tutorialButton6]
}
