//
//  City.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 25.08.2022.
//

import UIKit
import RealmSwift

class City: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var conditionDescription: String = ""
    @Persisted var temperature: String = ""
    var conditionImage: UIImage? = nil
    
    // Not for a cell use
    @Persisted var conditionCode: String = ""
    @Persisted var dayLight: Bool = true
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
    @Persisted var explorerMode: Bool = false
    
    convenience init(name: String,
                     conditionDescription: String,
                     temperature: String,
                     conditionImage: UIImage?,
                     conditionCode: String,
                     dayLight: Bool,
                     latitude: Double,
                     longitude: Double,
                     explorerMode: Bool) {
        self.init()
        self.name = name
        self.conditionDescription = conditionDescription
        self.temperature = temperature
        self.conditionImage = conditionImage
        self.conditionCode = conditionCode
        self.dayLight = dayLight
        self.latitude = latitude
        self.longitude = longitude
        self.explorerMode = explorerMode
    }
}
