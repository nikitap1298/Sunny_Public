//
//  SubscriptionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 06.05.23.
//

import UIKit
import QuartzCore

class SubscriptionView: UIView {
    
    let mainView = UIView()
    let titleLabel = UILabel()
    let headerLabel = UILabel()
    let descriptionLabel = UILabel()
    let monthlyButton = UIButton()
    let oneWeekTrialLabel = UILabel()
    let restorePurchasesButton = UIButton()

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
        mainView.addSubview(titleLabel)
        mainView.addSubview(headerLabel)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(monthlyButton)
        mainView.addSubview(oneWeekTrialLabel)
        mainView.addSubview(restorePurchasesButton)
        
        mainView.translateMask()
        titleLabel.translateMask()
        headerLabel.translateMask()
        descriptionLabel.translateMask()
        monthlyButton.translateMask()
        oneWeekTrialLabel.translateMask()
        restorePurchasesButton.translateMask()
        
        mainView.backgroundColor = SubscriptionColors.backgroundBottom
        mainView.addCornerRadius()
        mainView.addShadow()
        
        titleLabel.text = "Sunny"
        titleLabel.textAlignment = .center
        titleLabel.textColor = CustomColors.colorVanilla
        titleLabel.font = UIFont(name: CustomFonts.nunitoBold, size: 26)
        
        headerLabel.text = L10nSettings.subscriptionHeaderLabel
        headerLabel.textAlignment = .center
        headerLabel.textColor = CustomColors.colorVanilla
        headerLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        descriptionLabel.text = L10nSettings.subscriptionDescriptionLabel
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = CustomColors.colorVanilla
        descriptionLabel.font = UIFont(name: CustomFonts.nunitoRegular, size: 17)
        
        monthlyButton.setTitle(L10nSettings.subscriptionMonthlyButtonType1, for: .normal)
        monthlyButton.setTitleColor(SubscriptionColors.buttonTextColor, for: .normal)
        monthlyButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoMedium, size: 20)
        monthlyButton.backgroundColor = CustomColors.colorYellow
        monthlyButton.addCornerRadius()
        monthlyButton.addShadow(offset: .init(width: 5.0, height: 5.0))
        
        oneWeekTrialLabel.text = L10nSettings.subscriptionOneWeekTrialLabel
        oneWeekTrialLabel.textAlignment = .center
        oneWeekTrialLabel.textColor = CustomColors.colorVanilla
        oneWeekTrialLabel.font = UIFont(name: CustomFonts.nunitoRegular, size: 15)
        oneWeekTrialLabel.numberOfLines = 2
        
        restorePurchasesButton.setTitle(L10nSettings.subscriptionRestorePurchasesButton, for: .normal)
        restorePurchasesButton.setTitleColor(SubscriptionColors.buttonTextColor, for: .normal)
        restorePurchasesButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoMedium, size: 15)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            
            headerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            headerLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            headerLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            
            restorePurchasesButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20),
            restorePurchasesButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            restorePurchasesButton.widthAnchor.constraint(equalToConstant: 200),
            restorePurchasesButton.heightAnchor.constraint(equalToConstant: 50),
            
            oneWeekTrialLabel.bottomAnchor.constraint(equalTo: restorePurchasesButton.bottomAnchor, constant: -55),
            oneWeekTrialLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            oneWeekTrialLabel.widthAnchor.constraint(equalToConstant: 200),
            oneWeekTrialLabel.heightAnchor.constraint(equalToConstant: 50),
            
            monthlyButton.bottomAnchor.constraint(equalTo: oneWeekTrialLabel.topAnchor, constant: -5),
            monthlyButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 50),
            monthlyButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -50),
            monthlyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
