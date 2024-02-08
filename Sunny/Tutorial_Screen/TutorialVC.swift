//
//  TutorialVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 11.12.22.
//

import UIKit

class TutorialVC: UIViewController {
    
    private var sunImage: UIImageView = {
        let sunImage = UIImageView()
        sunImage.image = AboutImages.sun
        sunImage.contentMode = .scaleAspectFill
        sunImage.translateMask()
        return sunImage
    }()
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    private let tutorialCollectionCell = TutorialCollectionCell()
    private let tutorialCollectionView = TutorialCollectionView()
    private let tutorialButtonsView = TutorialButtonsView()
    private let tutorialModel = TutorialModel()
    
    private var collectionNumber: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addGradient(SubscriptionColors.backgroundTop, SubscriptionColors.backgroundBottom)
    }
    
    // MARK: - Actions
    @objc private func didTapButton() {
        sunImage.removeFromSuperview()
        
        DispatchQueue.main.async { [weak self] in
            self?.tutorialButtonsView.button.backgroundColor = CustomColors.colorYellow
            self?.tutorialButtonsView.button.setTitleColor(SubscriptionColors.buttonTextColor, for: .normal)
        }
        
        if collectionNumber < 6 {
            tutorialButtonsView.button.setTitle(tutorialModel.buttonText[collectionNumber], for: .normal)
    
            collectionNumber += 1
            tutorialCollectionView.collectionView.reloadData()
        } else if collectionNumber == 6 {
            let viewController = SubscriptionVC()
            navigationController?.pushViewController(viewController, animated: true)
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.initialLaunch)
        }
        
        hapticFeedback.notificationOccurred(.success)
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(sunImage)
        view.addSubview(tutorialCollectionView.collectionView)
        view.addSubview(tutorialButtonsView.mainView)
        
        NSLayoutConstraint.activate([
            sunImage.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -125),
//            sunImage.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            sunImage.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            tutorialCollectionView.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tutorialCollectionView.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tutorialCollectionView.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tutorialCollectionView.collectionView.bottomAnchor.constraint(equalTo: tutorialButtonsView.mainView.topAnchor, constant: -10),
            
            tutorialButtonsView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 75),
            tutorialButtonsView.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -75),
            tutorialButtonsView.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            tutorialButtonsView.mainView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tutorialCollectionView.collectionView.delegate = self
        tutorialCollectionView.collectionView.dataSource = self
        
        tutorialButtonsView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialModel.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tutorialCollectionView.collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCollectionCell.reuseIdentifier, for: indexPath) as? TutorialCollectionCell else {
            return UICollectionViewCell()
        }
        
        if collectionNumber != 0 {
            cell.tutorialImage.addShadow()
        }
        
        cell.setupTutorialImage(tutorialModel.imageArray[collectionNumber])
        cell.setupTutorialTitle(tutorialModel.titleArray[collectionNumber])
        cell.setupTutorialContent(tutorialModel.textArray[collectionNumber])
        return cell
    }
}

extension TutorialVC {
    
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = nil
    
        // Setup NavigationBar and remove bottom border
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Disable Back button
        navigationItem.setHidesBackButton(true, animated: true)
    }
}
