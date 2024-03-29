//
//  CustomFirstBlockButtons.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 11.08.2022.
//

import UIKit

// View for Temperature, Wind Speed, Pressure in SettingsVC
class CustomFirstBlockButtons: UIView {
    
    let settingsView = UIView()
    let settingsLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let valuesView = UIView()
    let leftValueLabel = UILabel()
    let rightValueLabel = UILabel()
    let switchView = UIView()
    
    var switchViewLeadingAnchor: NSLayoutConstraint?
    var switchViewTrailingAnhor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(settingsView)
        settingsView.addSubview(settingsLabel)
        settingsView.addSubview(valuesView)
        valuesView.addSubview(leftValueLabel)
        valuesView.addSubview(rightValueLabel)
        valuesView.addSubview(switchView)
        
        settingsView.translateMask()
        settingsLabel.translateMask()
        valuesView.translateMask()
        leftValueLabel.translateMask()
        rightValueLabel.translateMask()
        switchView.translateMask()
        
        settingsView.backgroundColor = SettingsColors.backgroungWhite
        
        settingsLabel.textAlignment = .left
        settingsLabel.textColor = SettingsColors.blockAndText
        settingsLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        valuesView.backgroundColor = SettingsColors.valueBackground
        valuesView.layer.cornerRadius = 10
        
        leftValueLabel.textAlignment = .center
        leftValueLabel.textColor = SettingsColors.blockAndText
        leftValueLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 17)
        
        rightValueLabel.textAlignment = .center
        rightValueLabel.textColor = SettingsColors.blockAndText
        rightValueLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 17)
        
        switchView.layer.cornerRadius = 10
        switchView.backgroundColor = CustomColors.colorBlue1?.withAlphaComponent(0.35)
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            settingsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            settingsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            settingsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            settingsLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 0),
            settingsLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 0),
            settingsLabel.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 0),
            settingsLabel.widthAnchor.constraint(equalToConstant: 200),
            
            valuesView.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 10),
            valuesView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -20),
            valuesView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -10),
            valuesView.widthAnchor.constraint(equalToConstant: 132),
            
            leftValueLabel.topAnchor.constraint(equalTo: valuesView.topAnchor),
            leftValueLabel.leadingAnchor.constraint(equalTo: valuesView.leadingAnchor),
            leftValueLabel.bottomAnchor.constraint(equalTo: valuesView.bottomAnchor),
            leftValueLabel.widthAnchor.constraint(equalToConstant: 66),
            
            rightValueLabel.topAnchor.constraint(equalTo: valuesView.topAnchor),
            rightValueLabel.trailingAnchor.constraint(equalTo: valuesView.trailingAnchor),
            rightValueLabel.bottomAnchor.constraint(equalTo: valuesView.bottomAnchor),
            rightValueLabel.widthAnchor.constraint(equalToConstant: 66),
            
            switchView.topAnchor.constraint(equalTo: valuesView.topAnchor),
            switchView.bottomAnchor.constraint(equalTo: valuesView.bottomAnchor),
            switchView.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        switchViewLeadingAnchor = switchView.leadingAnchor.constraint(equalTo: valuesView.leadingAnchor)
        switchViewTrailingAnhor = switchView.trailingAnchor.constraint(equalTo: valuesView.trailingAnchor)
        
        guard let switchViewLeadingAnchor = switchViewLeadingAnchor,
              let switchViewTrailingAnhor = switchViewTrailingAnhor else {
            return
        }
        
        switchViewLeadingAnchor.isActive = true
        switchViewTrailingAnhor.isActive = false
    }
}
