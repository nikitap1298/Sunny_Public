//
//  SearchCollectionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 24.08.2022.
//

import UIKit
import SwipeCellKit
import UIDeviceComplete

class SearchCollectionView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(collectionView)
        
        collectionView.translateMask()
        
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        // Register new custom CollectionViewCell
        collectionView.register(CustomSearchCollectionViewCell.self, forCellWithReuseIdentifier: CustomSearchCollectionViewCell.reuseIdentifier)
        
        // Set new collectionView layout
        collectionView.setCollectionViewLayout(generateTomottowCollectionLayout(), animated: true)
    }
    
    private func generateTomottowCollectionLayout() -> UICollectionViewLayout{
        var numberOfSections = 0
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = .init(top: 0, leading: 10, bottom: 20, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.collectionView.frame.height))
            
            // Different number of sections in CollectionView depending on the Device Model
            switch UIDevice.current.dc.deviceModel {
            case .iPodTouchSeventhGen,
                    .iPhone6S,
                    .iPhone7,
                    .iPhone8,
                    .iPhoneSE,
                    .iPhoneSE2,
                    .iPhoneSE3:
                numberOfSections = 4
            default:
                numberOfSections = 5
            }
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: numberOfSections)
            group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            return section
        }
    }
    
}

class CustomSearchCollectionViewCell: SwipeCollectionViewCell {
    
    static let reuseIdentifier = String(describing: CustomSearchCollectionViewCell.self)
    
    let mainView = UIView()
    let firstStackView = UIStackView()
    let secondStackView = UIStackView()
    let cityLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let descriptionLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let temperatureLabel = UILabel()
    let conditionImage = UIImageView()
    
    let latitudeLabel = UILabel()
    let longitudeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        cityLabel.text = nil
        descriptionLabel.text = nil
        temperatureLabel.text = nil
        conditionImage.image = nil
        latitudeLabel.text = nil
        longitudeLabel.text = nil
    }
    
    func setupCity(_ city: String) {
        cityLabel.text = city
        if cityLabel.text?.count ?? 0 > 20 {
            cityLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 16)
            descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 14)
        } else {
            cityLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
            descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        }
    }
    
    func setupDescription(_ description: String) {
        descriptionLabel.text = description
    }
    
    func setupTemperature(_ temperature: String) {
        temperatureLabel.text = temperature
    }
    
    func setupConditionImage(_ image: UIImage?) {
        conditionImage.image = image
    }
    
    func setupLatitude(_ latitude: Double) {
        latitudeLabel.text = String(latitude)
    }
    
    func setupLongitude(_ longitude: Double) {
        longitudeLabel.text = String(longitude)
    }
    
    private func setupUI() {
        contentView.addSubview(mainView)
        mainView.addSubview(firstStackView)
        mainView.addSubview(secondStackView)
        
        mainView.translateMask()
        firstStackView.translateMask()
        secondStackView.translateMask()
        
        mainView.backgroundColor = OnboardingColors.weatherBlock
        mainView.addCornerRadius()
        
        firstStackView.axis = .vertical
        firstStackView.distribution = .equalSpacing
        
        secondStackView.axis = .vertical
        secondStackView.distribution = .fillEqually
        secondStackView.spacing = 10
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            firstStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 15),
            firstStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            firstStackView.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: self.frame.midX / 3),
            firstStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -15),
            
            secondStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            secondStackView.leadingAnchor.constraint(equalTo: firstStackView.trailingAnchor, constant: 0),
            secondStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            secondStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
        ])
        
        addLabelsToFirstStackView()
        addLabelsToSecondStackView()
    }
    
    private func addLabelsToFirstStackView() {
        cityLabel.translateMask()
        descriptionLabel.translateMask()
        
        cityLabel.textAlignment = .left
        cityLabel.textColor = OnboardingColors.parametersText1
        cityLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = OnboardingColors.parametersText1
        descriptionLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        firstStackView.addArrangedSubview(cityLabel)
        firstStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addLabelsToSecondStackView() {
        temperatureLabel.translateMask()
        conditionImage.translateMask()
        
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = OnboardingColors.parametersText1
        temperatureLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 20)
        
        conditionImage.contentMode = .scaleAspectFit
        
        secondStackView.addArrangedSubview(conditionImage)
        secondStackView.addArrangedSubview(temperatureLabel)
    }
    
}
