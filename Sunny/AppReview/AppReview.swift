//
//  AppReview.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 16.12.22.
//

import UIKit
import StoreKit

// MARK: - AppReview
struct AppReview {
    
    static let threshhold = 2
    static var runsSinceLastRequest = 0
    static var version = ""
    
    static func requestReviewIfNeeded() {
        runsSinceLastRequest += 1
        guard let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return
        }
        guard let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return
        }
        let thisVersion = "\(appVersion) build: \(appBuild)"
       
        if thisVersion != version {
            if runsSinceLastRequest >= threshhold {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                    version = thisVersion
                    runsSinceLastRequest = 0
                }
            }
        } else {
            runsSinceLastRequest = 0
        }
        
    }
}
