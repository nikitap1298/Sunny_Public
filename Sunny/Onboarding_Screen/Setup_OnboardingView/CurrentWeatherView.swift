//
//  CurrentWeatherView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 26.08.2022.
//

import UIKit

class CurrentWeatherView: UIView {
    
    let mainView = UIView()
    let dateLabel = UILabel()
    let temperatureLabel = UILabel()
    let temperatureImage = UIImageView()
    let descriptionLabel = UILabel()
    let cityStackView = UIStackView()
    let cityImage = UIImageView()
    let cityNameLabel = UILabel()
    
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
        mainView.addSubview(dateLabel)
        mainView.addSubview(temperatureLabel)
        mainView.addSubview(temperatureImage)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(cityStackView)
        
        mainView.translateMask()
        dateLabel.translateMask()
        temperatureLabel.translateMask()
        temperatureImage.translateMask()
        descriptionLabel.translateMask()
        cityStackView.translateMask()
        
        mainView.backgroundColor = .clear
        
        dateLabel.textAlignment = .left
        dateLabel.textColor = CustomColors.colorRed
        dateLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        temperatureLabel.textAlignment = .left
        temperatureLabel.textColor = OnboardingColors.parametersText1
        temperatureLabel.font = UIFont(name: CustomFonts.nunitoBold, size: 45)
        
        temperatureImage.contentMode = .scaleAspectFit
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = OnboardingColors.parametersText1
        descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        cityStackView.axis = .horizontal
        cityStackView.spacing = 15
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            temperatureLabel.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 50),
            
            temperatureImage.centerYAnchor.constraint(equalTo: temperatureLabel.topAnchor),
            temperatureImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -40),
            temperatureImage.widthAnchor.constraint(equalToConstant: 70),
            temperatureImage.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: temperatureImage.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureImage.bottomAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            descriptionLabel.bottomAnchor.constraint(equalTo: cityStackView.topAnchor, constant: 0),

            dateLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
            dateLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -30),

            cityStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            cityStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 30),
            cityStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10)
        ])
        
        setupCityStackView()
    }
    
    private func setupCityStackView() {
        cityImage.translateMask()
        cityNameLabel.translateMask()
        
        cityImage.image = UIImages.location_2
        cityImage.tintColor = OnboardingColors.parametersText1
        cityImage.contentMode = .scaleAspectFit
        cityImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        cityNameLabel.textAlignment = .left
        cityNameLabel.text = L10nOnboarding.cityLabelText
        cityNameLabel.textColor = OnboardingColors.parametersText1
        cityNameLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        cityStackView.addArrangedSubview(cityImage)
        cityStackView.addArrangedSubview(cityNameLabel)
    }
}
