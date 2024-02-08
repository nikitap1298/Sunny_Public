//
//  TutorialButtons.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 11.12.22.
//

import UIKit

// MARK: - TutorialButtonsView
class TutorialButtonsView: UIView {
    
    let mainView = UIView()
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
        mainView.addSubview(button)
        
        mainView.translateMask()
        button.translateMask()
        
        button.addCornerRadius()
        button.addShadow(offset: .init(width: 5.0, height: 5.0))
        button.backgroundColor = CustomColors.colorBlue
        button.setTitle(L10nTutorial.tutorialButton0, for: .normal)
        button.setTitleColor(CustomColors.colorVanilla, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 18)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: mainView.topAnchor),
            button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
}
