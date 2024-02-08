//
//  FirstBlock.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 17.09.2022.
//

import UIKit

class FirstBlock: UIView {
    
    private let buttonHeight: CGFloat = 50
    
    let mainView = UIView()
    
    let temperature = CustomFirstBlockButtons()
    let speed = CustomFirstBlockButtons()
    let pressure = CustomFirstBlockButtons()
    let precipitation = CustomFirstBlockButtons()
    let distance = CustomFirstBlockButtons()
    let timeFormat = CustomFirstBlockButtons()
    
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
        mainView.addSubview(temperature)
        mainView.addSubview(speed)
        mainView.addSubview(pressure)
        mainView.addSubview(precipitation)
        mainView.addSubview(distance)
        mainView.addSubview(timeFormat)
        
        self.translateMask()
        mainView.translateMask()
        temperature.translateMask()
        speed.translateMask()
        pressure.translateMask()
        precipitation.translateMask()
        distance.translateMask()
        timeFormat.translateMask()
        
        mainView.backgroundColor = SettingsColors.blockAndText
        
        temperature.settingsLabel.text = L10nSettings.temperatureButtonText
        temperature.leftValueLabel.text = "ºC"
        temperature.rightValueLabel.text = "ºF"
        
        speed.settingsLabel.text = L10nSettings.speedButtonText
        speed.leftValueLabel.text = L10nSettings.speedButtonLeftValueText
        speed.rightValueLabel.text = L10nSettings.speedButtonRightValueText
        
        pressure.settingsLabel.text = L10nSettings.pressureButtonText
        pressure.leftValueLabel.text = L10nSettings.pressureButtonLeftValueText
        pressure.rightValueLabel.text = L10nSettings.pressureButtonRightValueText
        
        precipitation.settingsLabel.text = L10nSettings.precipitationButtonText
        precipitation.leftValueLabel.text = L10nSettings.precipitationButtonLeftValueText
        precipitation.rightValueLabel.text = L10nSettings.precipitationButtonRightValueText
        
        distance.settingsLabel.text = L10nSettings.distanceButtonText
        distance.leftValueLabel.text = L10nSettings.distanceButtonLeftValueText
        distance.rightValueLabel.text = L10nSettings.distanceButtonRightValueText
        
        timeFormat.settingsLabel.text = L10nSettings.timeFormatButtonText
        timeFormat.leftValueLabel.text = L10nSettings.timeFormatButtonLeftValueText
        timeFormat.rightValueLabel.text = L10nSettings.timeFormatButtonRightValueText
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            temperature.settingsView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 1),
            temperature.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            temperature.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            temperature.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            speed.settingsView.topAnchor.constraint(equalTo: temperature.settingsView.bottomAnchor, constant: 1),
            speed.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            speed.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            speed.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            pressure.settingsView.topAnchor.constraint(equalTo: speed.settingsView.bottomAnchor, constant: 1),
            pressure.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            pressure.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            pressure.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            precipitation.settingsView.topAnchor.constraint(equalTo: pressure.settingsView.bottomAnchor, constant: 1),
            precipitation.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            precipitation.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            precipitation.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            distance.settingsView.topAnchor.constraint(equalTo: precipitation.settingsView.bottomAnchor, constant: 1),
            distance.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            distance.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            distance.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            timeFormat.settingsView.topAnchor.constraint(equalTo: distance.settingsView.bottomAnchor, constant: 1),
            timeFormat.settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            timeFormat.settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            timeFormat.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
}
