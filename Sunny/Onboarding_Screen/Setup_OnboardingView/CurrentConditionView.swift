//
//  NowConditionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 18.08.2022.
//

import UIKit

// MARK: - CurrentConditionView
class CurrentConditionView: UIView {
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
        collectionView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Register new custom CollectionViewCell
        collectionView.register(CurrentConditionCell.self, forCellWithReuseIdentifier: CurrentConditionCell.reuseIdentifier)
        
        // Set new collectionView layout
        collectionView.setCollectionViewLayout(generateTodayCollectionLayout(), animated: true)
    }
    
    private func generateTodayCollectionLayout() -> UICollectionViewLayout{
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.collectionView.frame.height))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 10)
            group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}

// MARK: - CurrentConditionCell
class CurrentConditionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CurrentConditionCell.self)
    
    let mainView = UIView()
    let parameterInfoView = UIView()
    let parameterNameLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let parameterValueLabel = UILabel()
    let parameterImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        parameterInfoView.backgroundColor = nil
        parameterNameLabel.text = nil
        parameterValueLabel.text = nil
        parameterImage.image = nil
    }
    
    func setupInfoView(_ color: UIColor?) {
        parameterInfoView.backgroundColor = color
    }
    
    func setupConditionNameLabel(_ condition: String) {
        parameterNameLabel.text = condition
    }
    
    func setupConditionValueLabel(_ value: String) {
        parameterValueLabel.text = value
    }
    
    func setupConditionImage(_ image: UIImage?) {
        parameterImage.image = image
    }
    
    private func setupUI() {
        self.addSubview(mainView)
        mainView.addSubview(parameterInfoView)
        mainView.addSubview(parameterNameLabel)
        mainView.addSubview(parameterValueLabel)
        mainView.addSubview(parameterImage)
        
        mainView.translateMask()
        parameterInfoView.translateMask()
        parameterNameLabel.translateMask()
        parameterValueLabel.translateMask()
        parameterImage.translateMask()
        
        //        mainView.addShadow()
        mainView.backgroundColor = OnboardingColors.weatherBlock
        mainView.addCornerRadius()
        
        parameterInfoView.layer.cornerRadius = 2.5
        parameterInfoView.backgroundColor = .clear
        
        parameterNameLabel.textAlignment = .left
        parameterNameLabel.textColor = OnboardingColors.parametersText
        parameterNameLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        parameterValueLabel.textAlignment = .right
        parameterValueLabel.textColor = OnboardingColors.parametersText1
        parameterValueLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 16)
        
        parameterImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            parameterInfoView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5),
            parameterInfoView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            parameterInfoView.widthAnchor.constraint(equalToConstant: 5),
            parameterInfoView.heightAnchor.constraint(equalToConstant: 5),
            
            parameterNameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            parameterNameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            parameterNameLabel.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
            parameterNameLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            
            parameterImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            parameterImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            parameterImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            parameterImage.widthAnchor.constraint(equalToConstant: 50),
            
            parameterValueLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            parameterValueLabel.leadingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
            parameterValueLabel.trailingAnchor.constraint(equalTo: parameterImage.leadingAnchor, constant: -10),
            parameterValueLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
        ])
        
    }
}
