//
//  GraphModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 27.08.2022.
//

import UIKit
import DGCharts

// MARK: - XAxisValueFormatter
class XAxisValueFormatter: NSObject, AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timeFormatIsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.timeFormat) as? Bool
        
        if timeFormatIsDef == true || timeFormatIsDef == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:00"
            let date = Date(timeIntervalSince1970: value)
            let time = dateFormatter.string(from: date)
            
            axis?.setLabelCount(5, force: true)
            if axis?.entries.last == value {
                return ""
            } else if axis?.entries.first == value {
                return ""
            }
            
            return time
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:00 a"
            let date = Date(timeIntervalSince1970: value)
            let time = dateFormatter.string(from: date)
            
            axis?.setLabelCount(5, force: true)
            if axis?.entries.last == value {
                return ""
            } else if axis?.entries.first == value {
                return ""
            }
            
            return time
        }
    }
}

// MARK: - YAxisValueFormatterTemperature
class YAxisValueFormatterTemperature: NSObject, AxisValueFormatter {

    private var converter = Converter()

    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        converter.convertTemperature(value)
    }

}

// MARK: - YAxisValueFormatterPrecipitation
class YAxisValueFormatterPrecipitation: NSObject, AxisValueFormatter {
    
    private var converter = Converter()
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        var customValue = value
        if value <= 0.0 {
            axis?.axisMinimum = 0.0
            customValue = 0.0
        }
        return converter.convertPrecipitation(customValue)
    }
}

// MARK: - YAxisValueFormatterPressure
class YAxisValueFormatterPressure: NSObject, AxisValueFormatter {
    
    private var converter = Converter()
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        converter.convertPressure(value)
    }
}

// MARK: - YAxisValueFormatterHumidity
class YAxisValueFormatterHumidity: NSObject, AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        var customValue = value
        if value <= 0.0 {
            axis?.axisMinimum = 0.0
            customValue = 0.0
        }
        return "\(Int(customValue * 100)) %"
    }
}

// MARK: - YAxisValueFormatterVisibility
class YAxisValueFormatterVisibility: NSObject, AxisValueFormatter {
    
    private var converter = Converter()
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        return converter.convertKmToMil(value)
    }
}

// MARK: - YAxisValueFormatterSpeed
class YAxisValueFormatterSpeed: NSObject, AxisValueFormatter {
    
    private var converter = Converter()
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        var customValue = value
        if value <= 0.0 {
            axis?.axisMinimum = 0.0
            customValue = 0.0
        }
        return converter.convertSpeed(customValue)
    }
}

// MARK: - YAxisValueFormatterTemperature
class YAxisValueFormatterUVIndex: NSObject, AxisValueFormatter {

    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        axis?.axisMinimum = 0.0
        return "\(Int(value))"
    }

}
