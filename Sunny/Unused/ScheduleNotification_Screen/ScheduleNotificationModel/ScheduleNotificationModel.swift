//
//  ScheduleNotificationModel.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 12.06.23.
//

import UIKit

struct ScheduleNotificationModel {
    
    private let scheduleNotificationView = ScheduleNotificationView()
    
    // Helper function to get the index of the current hour
    func current24HourIndex() -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: Date())
            let currentHour = components.hour ?? 0
            if let index = scheduleNotificationView.hours24.firstIndex(of: currentHour) {
                return index
            }
            return 0
        }
    
    func current12HourIndex(_ is24hFormat: Bool) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        let currentHour = components.hour ?? 0
        
        if is24hFormat {
            if let index = scheduleNotificationView.hours24.firstIndex(of: currentHour) {
                return index
            }
        } else {
            let twelveHour = (currentHour + 11) % 12 + 1
            if let index = scheduleNotificationView.hours12.firstIndex(of: twelveHour) {
                return index
            }
        }
        
        return 0
    }

    // Helper function to get the index of the current minute
    func currentMinuteIndex() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: Date())
        let currentMinute = components.minute ?? 0
        
        if let index = scheduleNotificationView.minutes.firstIndex(of: currentMinute) {
            return index
        }
        
        return 0
    }

    // Helper function to get the index of the current AM/PM
    func currentAmPmIndex() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        let currentHour = components.hour ?? 0
        
        if let index = scheduleNotificationView.amPM.firstIndex(where: { $0.lowercased() == (currentHour >= 12 ? "pm" : "am") }) {
            return index
        }
        
        return 0
    }
}
