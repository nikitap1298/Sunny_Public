//
//  ScheduleNotificationView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 12.06.23.
//

import UIKit

class ScheduleNotificationView: UIView {
    
    let mainView = UIView()
    let descriptionLabel = UILabel()
    let currentNotificationLabel = UILabel()
    let timePickerView = UIPickerView()
    let toggleStackView = UIStackView()
    let toggleLabel = UILabel()
    let toggleButton = UISwitch()
    let setNotificationButton = UIButton()
    
    let hours24 = Array(0...23)
    let hours12 = Array(1...12)
    let minutes = Array(0...59)
    let amPM = ["AM", "PM"]
    
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
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(currentNotificationLabel)
        mainView.addSubview(timePickerView)
        mainView.addSubview(toggleStackView)
        mainView.addSubview(setNotificationButton)
        
        self.translateMask()
        mainView.translateMask()
        descriptionLabel.translateMask()
        currentNotificationLabel.translateMask()
        timePickerView.translateMask()
        toggleStackView.translateMask()
        setNotificationButton.translateMask()
        
        mainView.addCornerRadius()
        mainView.backgroundColor = SettingsColors.backgroungWhite
        
        descriptionLabel.text = "Set the time when you want to receive weather notification for the day"
        descriptionLabel.numberOfLines = 4
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = OnboardingColors.parametersText1
        descriptionLabel.font = UIFont(name: CustomFonts.nunitoRegular, size: 18)
        
        currentNotificationLabel.text = ""
        currentNotificationLabel.textAlignment = .center
        currentNotificationLabel.textColor = SubscriptionColors.backgroundBottom
        currentNotificationLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 18)
        
        toggleStackView.axis = .horizontal
        toggleStackView.alignment = .center
        toggleStackView.distribution = .equalCentering
        
        setNotificationButton.setTitle("Save", for: .normal)
        setNotificationButton.setTitleColor(OnboardingColors.parametersText1, for: .normal)
        setNotificationButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoMedium, size: 20)
        setNotificationButton.backgroundColor = SubscriptionColors.backgroundBottom
        setNotificationButton.addCornerRadius()
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 75),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -75),
            descriptionLabel.bottomAnchor.constraint(equalTo: currentNotificationLabel.topAnchor, constant: -35),
            
            currentNotificationLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 75),
            currentNotificationLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -75),
            currentNotificationLabel.bottomAnchor.constraint(equalTo: timePickerView.topAnchor, constant: -25),

            timePickerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: -25),
            timePickerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 50),
            timePickerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -50),
            timePickerView.heightAnchor.constraint(equalToConstant: 150),
            
            toggleStackView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 50),
            toggleStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 80),
            toggleStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -80),
            toggleStackView.heightAnchor.constraint(equalToConstant: 50),
            
            setNotificationButton.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor, constant: 50),
            setNotificationButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 100),
            setNotificationButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -100),
            setNotificationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupStackView()
    }
    
    private func setupStackView() {
        toggleLabel.translateMask()
        toggleButton.translateMask()
        
        toggleLabel.text = "Notification"
        toggleLabel.textAlignment = .left
        toggleLabel.textColor = OnboardingColors.parametersText1
        toggleLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 18)

        toggleButton.isOn = false
        
        toggleStackView.addArrangedSubview(toggleLabel)
        toggleStackView.addArrangedSubview(toggleButton)
    }
}
