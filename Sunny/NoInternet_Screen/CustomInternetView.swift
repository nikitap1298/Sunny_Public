//
//  CustomInternetView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 20.09.2022.
//

import UIKit

// MARK: - CustomIntentetView
class CustomIntentetView: UIView {
    
    // MARK: - Private Properties
    private let currentLanguage = Locale.current.languageCode
    
    // MARK: - Public Properties
    let stackView = UIStackView()
    let imageView = UIImageView()
    let textLabelFirst = UILabel()
    let textLabelSecond = UILabel()
    let goToDeviceSettingsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        
        stackView.translateMask()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        setupStackView()
    }
    
    private func setupStackView() {
        imageView.translateMask()
        textLabelFirst.translateMask()
        textLabelSecond.translateMask()
        goToDeviceSettingsButton.translateMask()
        
        imageView.image = UIImage(systemName: "wifi.slash")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = CustomColors.colorGray
        
        textLabelFirst.text = L10nNoInternet.weatherUnavailableLabelText
        textLabelFirst.textAlignment = .center
        textLabelFirst.textColor = OnboardingColors.parametersText1
        textLabelFirst.font = UIFont(name: CustomFonts.nunitoBold, size: 24)
        
        textLabelSecond.text = L10nNoInternet.noInternetLabelText
        textLabelSecond.textAlignment = .center
        
        textLabelSecond.lineBreakMode = .byWordWrapping
        textLabelSecond.textColor = OnboardingColors.parametersText1
        textLabelSecond.font = UIFont(name: CustomFonts.nunitoMedium, size: 17)
        
        goToDeviceSettingsButton.setTitle(L10nNoInternet.goToSettingsButtonText, for: .normal)
        goToDeviceSettingsButton.tintColor = CustomColors.colorVanilla
        goToDeviceSettingsButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoMedium, size: 17)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabelFirst)
        stackView.addArrangedSubview(textLabelSecond)
        stackView.addArrangedSubview(goToDeviceSettingsButton)
    }
}
