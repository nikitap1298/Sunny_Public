//
//  TutorialCollectionView.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 11.12.22.
//

import UIKit

// MARK: - TutorialCollectionView
class TutorialCollectionView: UIView {
    
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
        collectionView.isUserInteractionEnabled = false
        collectionView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        // Register new custom CollectionViewCell
        collectionView.register(TutorialCollectionCell.self, forCellWithReuseIdentifier: TutorialCollectionCell.reuseIdentifier)
        
        // Set new collectionView layout
        collectionView.setCollectionViewLayout(generateTutorialCollectionLayout(), animated: true)
    }
    
    private func generateTutorialCollectionLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.collectionView.frame.height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
}

// MARK: - CustomTutorialCollectionCell
class TutorialCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: TutorialCollectionCell.self)
    
    let mainView = UIView()
    let tutorialImage = UIImageView()
    let tutorialTitle = UILabel()
    let tutorialContent = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tutorialImage.alpha = 0.0
        tutorialTitle.alpha = 0.0
        tutorialContent.alpha = 0.0
        tutorialTitle.textColor = CustomColors.colorVanilla
        tutorialTitle.font = UIFont(name: CustomFonts.nunitoBold, size: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animateFadeIn()
    }
    
    func setupTutorialImage(_ image: UIImage?) {
        tutorialImage.image = image
    }
    
    func setupTutorialTitle(_ text: String) {
        tutorialTitle.text = text
    }
    
    func setupTutorialContent(_ text: String) {
        tutorialContent.text = text
    }
    
    private func animateFadeIn() {
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [.curveEaseInOut], animations: {
            self.tutorialImage.alpha = 1.0
            self.tutorialTitle.alpha = 1.0
            self.tutorialContent.alpha = 1.0
        }, completion: nil)
    }
    
    private func setupUI() {
        contentView.addSubview(mainView)
        mainView.addSubview(tutorialImage)
        mainView.addSubview(tutorialTitle)
        mainView.addSubview(tutorialContent)
        
        mainView.translateMask()
        tutorialImage.translateMask()
        tutorialTitle.translateMask()
        tutorialContent.translateMask()
        
//        mainView.backgroundColor = CustomColors.colorVanilla
        
        tutorialImage.contentMode = .scaleAspectFit
        
        tutorialTitle.numberOfLines = 1
        tutorialTitle.textAlignment = .center
        tutorialTitle.textColor = CustomColors.colorBlue
        tutorialTitle.font = UIFont(name: CustomFonts.nunitoBold, size: 24)
        
        tutorialContent.numberOfLines = 6
        tutorialContent.textAlignment = .center
        tutorialContent.textColor = CustomColors.colorVanilla
        tutorialContent.font = UIFont(name: CustomFonts.nunitoMedium, size: 18)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tutorialImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            tutorialImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tutorialImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            tutorialImage.bottomAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 0),
            
            tutorialTitle.topAnchor.constraint(equalTo: tutorialImage.bottomAnchor, constant: 30),
            tutorialTitle.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tutorialTitle.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
//            tutorialTitle.heightAnchor.constraint(equalToConstant: 25),
            
            tutorialContent.topAnchor.constraint(equalTo: tutorialTitle.bottomAnchor, constant: 30),
            tutorialContent.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            tutorialContent.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
//            tutorialContent.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

