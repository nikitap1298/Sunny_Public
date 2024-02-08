//
//  ClothesType.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 14.09.2022.
//

import UIKit

struct ClothesType {
    
    func description(_ temperatureApparent: Double, _ windSpeed: Double) -> String {
        if temperatureApparent >= 27.4 {
            return L10nClothesDescription.tShirtText
        } else if temperatureApparent >= 23.4 && windSpeed < 18 {
            return L10nClothesDescription.tShirtText
        } else if temperatureApparent >= 19.4 && windSpeed < 28 {
            return L10nClothesDescription.shirtText
        } else if temperatureApparent >= 10.4 && windSpeed < 36 {
            return L10nClothesDescription.hoodieText
        } else if temperatureApparent >= 2.4 && windSpeed < 54 {
            return L10nClothesDescription.jacketText
        } else if temperatureApparent < 2.4 && windSpeed < 72 {
            return L10nClothesDescription.warmJacketText
        } else {
            return L10nClothesDescription.tShirtText
        }
    }
    
    func image(_ temperatureApparent: Double, _ windSpeed: Double) -> UIImage? {
        if temperatureApparent >= 27.4 {
            return Clothes.tShirt
        } else if temperatureApparent >= 23.4 && windSpeed < 18 {
            return Clothes.tShirt
        } else if temperatureApparent >= 19.4 && windSpeed < 28 {
            return Clothes.shirt
        } else if temperatureApparent >= 10.4 && windSpeed < 36 {
            return Clothes.hoodie
        } else if temperatureApparent >= 2.4 && windSpeed < 54 {
            return Clothes.jacket
        } else if temperatureApparent < 2.4 && windSpeed < 72 {
            return Clothes.jacketWarm
        } else {
            return Clothes.tShirt
        }
    }
}
