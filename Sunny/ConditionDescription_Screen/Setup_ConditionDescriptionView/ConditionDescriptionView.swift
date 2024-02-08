//
//  ConditionDescriptionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 09.06.23.
//

import UIKit

// MARK: - ConditionDescriptionView
class ConditionDescriptionView: UIView {
    
    let mainView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(mainView)
        
        mainView.translateMask()
       
        mainView.backgroundColor = OnboardingColors.weatherBlock
        mainView.addCornerRadius()
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

