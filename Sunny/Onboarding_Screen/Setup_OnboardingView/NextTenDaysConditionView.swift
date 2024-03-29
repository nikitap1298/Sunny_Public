//
//  NextTenDaysConditionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 18.08.2022.
//

import UIKit

// MARK: - NextTenDaysConditionView
class NextTenDaysConditionView: UIView {
    
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
            
            // Equal 550 because last cell must have space from bottom of collection view too.
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Register new custom CollectionViewCell
        collectionView.register(NextSevenDaysConditionCell.self, forCellWithReuseIdentifier: NextSevenDaysConditionCell.reuseIdentifier)
        
        // Set new collectionView layout
        collectionView.setCollectionViewLayout(generateDayConditionCollectionLayout(), animated: true)
    }
    
    private func generateDayConditionCollectionLayout() -> UICollectionViewLayout{
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

// MARK: - NextSevenDaysConditionCell
class NextSevenDaysConditionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: NextSevenDaysConditionCell.self)
    
    let mainView = UIView()
    let dateLabel = PaddingLabel(withInsets: 0, 0, 15, 0)
    let stackView = UIStackView()
    let temperatureMinLabel = UILabel()
    let temperatureMaxLabel = UILabel()
    let conditionImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        temperatureMinLabel.text = nil
        temperatureMaxLabel.text = nil
        conditionImage.image = nil
    }
    
    func setupDate(_ date: String) {
        dateLabel.text = date
    }
    
    func setupTemperatureLabel(_ min: String, _ max: String) {
        temperatureMinLabel.text = min
        temperatureMaxLabel.text = max    }
    
    func setupConditionImage(_ image: UIImage?) {
        conditionImage.image = image
    }
    
    private func setupUI() {
        contentView.addSubview(mainView)
        mainView.addSubview(dateLabel)
        mainView.addSubview(stackView)
        mainView.addSubview(conditionImage)
        
        mainView.translateMask()
        dateLabel.translateMask()
        stackView.translateMask()
        conditionImage.translateMask()
        
        mainView.backgroundColor = OnboardingColors.weatherBlock
        mainView.addCornerRadius()

        dateLabel.textAlignment = .left
        dateLabel.textColor = OnboardingColors.parametersText
        dateLabel.font = UIFont(name: CustomFonts.nunitoMedium, size: 16)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        conditionImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            dateLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
            
            conditionImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            conditionImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            conditionImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            conditionImage.widthAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: conditionImage.leadingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
        ])
        addLabelsToStackView()
    }
    
    private func addLabelsToStackView() {
        temperatureMinLabel.translateMask()
        temperatureMaxLabel.translateMask()
        
        temperatureMinLabel.textAlignment = .right
        temperatureMinLabel.textColor = OnboardingColors.parametersText
        temperatureMinLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 13)
        
        temperatureMaxLabel.textAlignment = .right
        temperatureMaxLabel.textColor = OnboardingColors.parametersText1
        temperatureMaxLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 16)
        
        stackView.addArrangedSubview(temperatureMaxLabel)
        stackView.addArrangedSubview(temperatureMinLabel)
    }
}
