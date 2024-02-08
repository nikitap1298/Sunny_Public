//
//  PopUpButton.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 15.11.2022.
//

import UIKit

class PopUpButtonView: UIView {
    
    let mainView = UIView()
    let buttonLabel = UILabel()
    let button = UIButton()
    
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
        mainView.addSubview(buttonLabel)
        mainView.addSubview(button)
        
        mainView.translateMask()
        buttonLabel.translateMask()
        button.translateMask()
        
        buttonLabel.textAlignment = .right
        buttonLabel.textColor = OnboardingColors.graphText
        buttonLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        button.setImage(ConditionImages.thermometerHot, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("^", for: .normal)
        button.tintColor = .black
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            buttonLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            buttonLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -20),
            buttonLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            buttonLabel.widthAnchor.constraint(equalToConstant: 150),
            
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
