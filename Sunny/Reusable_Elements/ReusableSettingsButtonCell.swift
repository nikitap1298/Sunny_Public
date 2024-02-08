//
//  ReusableSettingsButton.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.12.22.
//

import UIKit

// MARK: - ReusableSettingsButton (Reusable)

// Common buttons in Settings
class ReusableSettingsButtonCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ReusableSettingsButtonCell.self)
    
    let buttonView = UIView()
    let titleLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let textLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        textLabel.text = nil
        imageView.image = nil
    }
    
    func setupTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setupText(_ text: String) {
        textLabel.text = text
    }
    
    func setupImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    private func setupUI() {
        self.addSubview(buttonView)
        buttonView.addSubview(titleLabel)
        buttonView.addSubview(textLabel)
        buttonView.addSubview(imageView)
        
        buttonView.translateMask()
        titleLabel.translateMask()
        textLabel.translateMask()
        imageView.translateMask()
        
        buttonView.backgroundColor = SettingsColors.backgroungWhite
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = SettingsColors.blockAndText
        titleLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        textLabel.textAlignment = .right
        textLabel.textColor = SettingsColors.blockAndText
        textLabel.font = UIFont(name: CustomFonts.nunitoRegular, size: 20)
        
        imageView.tintColor = SettingsColors.blockAndText
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            buttonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            buttonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: buttonView.centerXAnchor, constant: 0),
            
            imageView.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -12),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            textLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 0)
        ])
    }
}

