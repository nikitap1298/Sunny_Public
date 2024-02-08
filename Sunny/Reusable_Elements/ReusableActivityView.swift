//
//  ActivityView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 18.05.23.
//

import UIKit

class ReusableActivityView: UIView {
    
    let mainView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(mainView)
        mainView.addSubview(activityIndicator)
        
        mainView.translateMask()
        activityIndicator.translateMask()
        
        mainView.backgroundColor = SettingsColors.backgroungWhite?.withAlphaComponent(0.4)
        
        activityIndicator.color = OnboardingColors.weatherKitText
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: mainView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
}
