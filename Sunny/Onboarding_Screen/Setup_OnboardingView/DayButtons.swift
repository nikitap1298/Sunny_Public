//
//  OnboardingReusableView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 15.08.2022.
//

import UIKit

// MARK: - DayButtons
class DayButtons: UIView {
    
    let stackView = UIStackView()
    let todayButton = UIButton()
    let nextTenDaysButton = UIButton()
    
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
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 100
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        addButtonsToStackView()
    }
    
    private func addButtonsToStackView() {
        todayButton.translateMask()
        nextTenDaysButton.translateMask()
        
        todayButton.setTitle(L10nOnboarding.todayButtonText, for: .normal)
        todayButton.contentHorizontalAlignment = .center
        todayButton.setTitleColor(CustomColors.colorVanilla, for: .normal)
//        todayButton.backgroundColor = .white
        todayButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 16)
        stackView.addArrangedSubview(todayButton)
        
        nextTenDaysButton.setTitle(L10nOnboarding.next10DaysButtonText, for: .normal)
        nextTenDaysButton.contentHorizontalAlignment = .center
        nextTenDaysButton.setTitleColor(OnboardingColors.dayButtonsUnSelected, for: .normal)
//        nexFiveDaysButton.backgroundColor = .white
        nextTenDaysButton.titleLabel?.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 16)
        stackView.addArrangedSubview(nextTenDaysButton)
    }
}
