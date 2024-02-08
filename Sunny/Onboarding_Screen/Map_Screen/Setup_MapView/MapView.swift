//
//  MapView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 31.08.23.
//

import UIKit
import MapKit
import SwiftUI

class MapView: UIView {
    
    let map = MKMapView()
    private let buttonsStackView = UIStackView()
    let placesButton = UIButton()
    private let divider = UIView()
    let mapTypeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(map)
        map.addSubview(buttonsStackView)
        
        map.translateMask()
        buttonsStackView.translateMask()
        
        buttonsStackView.layer.cornerRadius = 15
        buttonsStackView.axis = .vertical
        buttonsStackView.distribution = .fillProportionally
        buttonsStackView.backgroundColor = OnboardingColors.parametersText1?.withAlphaComponent(0.9)
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: self.topAnchor),
            map.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: map.topAnchor, constant: 115),
            buttonsStackView.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -15),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 50),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 101)
        ])
        
        setupButtonsStackView()
    }
    
    private func setupButtonsStackView() {
        placesButton.translateMask()
        divider.translateMask()
        mapTypeButton.translateMask()
        
        placesButton.setImage(UIImage(systemName: "list.clipboard.fill"), for: .normal)
        placesButton.tintColor = .systemGray4
        
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        mapTypeButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
        mapTypeButton.tintColor = .systemGray4
        
        buttonsStackView.addArrangedSubview(mapTypeButton)
        buttonsStackView.addArrangedSubview(divider)
        buttonsStackView.addArrangedSubview(placesButton)
    }
}
