//
//  ReusableConditionalSquareViewCell.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.12.22.
//

import UIKit

// This type of cell is using inside HourVC & DayVC
class ReusableConditionalSquareViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ReusableConditionalSquareViewCell.self)
    
    let stackView = UIStackView()
    let parameterNameLabel = UILabel()
    let parameterImageView = UIImageView()
    let parameterValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        parameterNameLabel.text = nil
        parameterImageView.image = nil
        parameterValueLabel.text = nil
    }
    
    func setupParameterName(_ name: String) {
        parameterNameLabel.text = name
    }
    
    func setupParameterImage(_ image: UIImage?) {
        parameterImageView.image = image
    }
    
    func setupParameterValue(_ value: String) {
        parameterValueLabel.text = value
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        
        stackView.translateMask()
       
        stackView.backgroundColor = OnboardingColors.weatherBlock
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        stackView.addCornerRadius()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        addLabelsToStackView()
    }
    
    private func addLabelsToStackView() {
        parameterNameLabel.translateMask()
        parameterImageView.translateMask()
        parameterValueLabel.translateMask()
        
        parameterNameLabel.textAlignment = .center
        parameterNameLabel.textColor = OnboardingColors.parametersText
        parameterNameLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 18)
        
        parameterImageView.contentMode = .scaleAspectFit
        parameterImageView.clipsToBounds = true
        
        parameterValueLabel.textAlignment = .center
        parameterValueLabel.textColor = OnboardingColors.parametersText1
        parameterValueLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        stackView.addArrangedSubview(parameterNameLabel)
        stackView.addArrangedSubview(parameterImageView)
        stackView.addArrangedSubview(parameterValueLabel)
    }
    
}

