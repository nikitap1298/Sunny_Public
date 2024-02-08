//
//  CustomAccessoryView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 15.08.23.
//

import UIKit

// MARK: - TextView
class CustomAccessoryView: UIView {
    let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let minusButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        accessoryView.addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        accessoryView.backgroundColor = traitCollection.userInterfaceStyle == .light ? .systemGray4 : .systemGray5
        
        minusButton.setTitle("−", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        minusButton.tintColor = traitCollection.userInterfaceStyle == .light ? .black : .white
        
        NSLayoutConstraint.activate([
            minusButton.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -15)
        ])
    }
}
