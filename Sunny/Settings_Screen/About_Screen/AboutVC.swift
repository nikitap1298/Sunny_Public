//
//  AboutViewContoller.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 22.07.2022.
//

import UIKit

class AboutVC: UIViewController {
    
    // MARK: - Private Properties
    private var sunImage: UIImageView = {
        let sunImage = UIImageView()
        sunImage.image = AboutImages.sun
        sunImage.translateMask()
        return sunImage
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Sunny"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: CustomFonts.nunitoSemiBold, size: 40)
        nameLabel.textColor = CustomColors.colorYellow
        nameLabel.translateMask()
        return nameLabel
    }()
    
    private let aboutButtonsView = AboutButtonsView()
    private var aboutButtonsModel = AboutButtonsModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SettingsColors.backgroungWhite
        
        customNavigationBar()
        setupSunImage()
        setupNameLabel()
        setupCustomAboutButtonsView()
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    // MARK: - Private Functions
    private func setupSunImage() {
        view.addSubview(sunImage)
        
        NSLayoutConstraint.activate([
            sunImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            sunImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            sunImage.widthAnchor.constraint(equalToConstant: 120),
            sunImage.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: sunImage.bottomAnchor, constant: 40),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    private func setupCustomAboutButtonsView() {
        view.addSubview(aboutButtonsView.collectionView)
        
        NSLayoutConstraint.activate([
            aboutButtonsView.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            aboutButtonsView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            aboutButtonsView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        aboutButtonsView.collectionView.delegate = self
        aboutButtonsView.collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AboutVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aboutButtonsModel.textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = aboutButtonsView.collectionView.dequeueReusableCell(withReuseIdentifier: ReusableSettingsButtonCell.reuseIdentifier, for: indexPath) as? ReusableSettingsButtonCell else {
            return UICollectionViewCell()
        }
        cell.setupTitle(aboutButtonsModel.titleArray[indexPath.row])
        cell.setupText(aboutButtonsModel.textArray[indexPath.row])
        cell.setupImage(aboutButtonsModel.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let url = URL(string: "https://github.com/nikitap1298") {
                UIApplication.shared.open(url)
            }
        case 2:
            if let url = URL(string: "https://www.flaticon.com") {
                UIApplication.shared.open(url)
            }
        case 3:
            if let url = URL(string: "https://icons8.com") {
                UIApplication.shared.open(url)
            }
        case 4:
            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula") {
                UIApplication.shared.open(url)
            }
        case 5:
            if let url = URL(string: "https://www.termsfeed.com/live/821d5f3f-0016-454f-a548-8c81466c331c") {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
}

// MARK: - AboutVC
private extension AboutVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nSettings.aboutNavText
        appearance.titleTextAttributes = [
            .foregroundColor: OtherUIColors.navigationItems as Any,
            .font: UIFont(name: CustomFonts.nunitoBold, size: 26) ?? UIFont.systemFont(ofSize: 26)
        ]
        
        // Setup NavigationBar and remove bottom border
        navigationItem.standardAppearance = appearance
        
        // Disable back button
        navigationItem.setHidesBackButton(true, animated: true)
        
        // Custom left button
        let backButton = UIButton()
        backButton.customNavigationButton(UIImages.backLeft,
                                          OtherUIColors.navigationItems)
        let leftButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButton
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Swipe to go back
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeBack(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc func didSwipeBack(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            navigationController?.popViewControllerToRightType1()
        }
    }
}

// Get app version
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
