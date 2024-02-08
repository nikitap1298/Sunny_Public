//
//  SettingsViewController.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.07.2022.
//

import UIKit
import MessageUI
import SPIndicator
import StoreKit

class SettingsVC: UIViewController {
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    private let reusableMainScrollView = ReusableMainScrollView()
    private let firstBlock = FirstBlock()
    private let secondBlock = SecondBlock()
    
    private var temperatureIsDefault = true
    private var speedIsDefault = true
    private var pressureIsDefault = true
    private var precipitationIsDefault = true
    private var distanсeIsDefault = true
    private var timeFormatIsDefault = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
        setupScrollView()
        
        setupBlocks()
        
        setupUserDefaults()
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToLeftType1()
    }
    
    @objc private func didTapTemperatureView() {
        if temperatureIsDefault == true {
            firstBlock.temperature.switchViewLeadingAnchor?.isActive = false
            firstBlock.temperature.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.temperature.valuesView.layoutIfNeeded()
                self?.temperatureIsDefault = false
                UserDefaults.standard.set(self?.temperatureIsDefault, forKey: UserDefaultsKeys.temperature)
            }
        } else {
            firstBlock.temperature.switchViewLeadingAnchor?.isActive = true
            firstBlock.temperature.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.temperature.valuesView.layoutIfNeeded()
                self?.temperatureIsDefault = true
                UserDefaults.standard.set(self?.temperatureIsDefault, forKey: UserDefaultsKeys.temperature)
            }
        }
        
        // This is using in SearchVC
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.temperatureButtonChange)
        
        // Haptic feedback for Temperature button
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapSpeedView() {
        if speedIsDefault == true {
            firstBlock.speed.switchViewLeadingAnchor?.isActive = false
            firstBlock.speed.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.speed.valuesView.layoutIfNeeded()
                self?.speedIsDefault = false
                UserDefaults.standard.set(self?.speedIsDefault, forKey: UserDefaultsKeys.speed)
            }
        } else {
            firstBlock.speed.switchViewLeadingAnchor?.isActive = true
            firstBlock.speed.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.speed.valuesView.layoutIfNeeded()
                self?.speedIsDefault = true
                UserDefaults.standard.set(self?.speedIsDefault, forKey: UserDefaultsKeys.speed)
            }
        }
        
        // Haptic feedback for Speed button
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapPressureView() {
        if pressureIsDefault == true {
            firstBlock.pressure.switchViewLeadingAnchor?.isActive = false
            firstBlock.pressure.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.pressure.valuesView.layoutIfNeeded()
                self?.pressureIsDefault = false
                UserDefaults.standard.set(self?.pressureIsDefault, forKey: UserDefaultsKeys.pressure)
            }
        } else {
            firstBlock.pressure.switchViewLeadingAnchor?.isActive = true
            firstBlock.pressure.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.pressure.valuesView.layoutIfNeeded()
                self?.pressureIsDefault = true
                UserDefaults.standard.set(self?.pressureIsDefault, forKey: UserDefaultsKeys.pressure)
            }
        }
        
        // Haptic feedback for Pressure button
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapPrecipitationView() {
        if precipitationIsDefault == true {
            firstBlock.precipitation.switchViewLeadingAnchor?.isActive = false
            firstBlock.precipitation.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.precipitation.valuesView.layoutIfNeeded()
                self?.precipitationIsDefault = false
                UserDefaults.standard.set(self?.precipitationIsDefault, forKey: UserDefaultsKeys.precipitation)
            }
        } else {
            firstBlock.precipitation.switchViewLeadingAnchor?.isActive = true
            firstBlock.precipitation.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.precipitation.valuesView.layoutIfNeeded()
                self?.precipitationIsDefault = true
                UserDefaults.standard.set(self?.precipitationIsDefault, forKey: UserDefaultsKeys.precipitation)
            }
        }
        
        // Haptic feedback for Precipitation button
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapDistanсeView() {
        if distanсeIsDefault == true {
            firstBlock.distance.switchViewLeadingAnchor?.isActive = false
            firstBlock.distance.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.distance.valuesView.layoutIfNeeded()
                self?.distanсeIsDefault = false
                UserDefaults.standard.set(self?.distanсeIsDefault, forKey: UserDefaultsKeys.distance)
            }
        } else {
            firstBlock.distance.switchViewLeadingAnchor?.isActive = true
            firstBlock.distance.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.distance.valuesView.layoutIfNeeded()
                self?.distanсeIsDefault = true
                UserDefaults.standard.set(self?.distanсeIsDefault, forKey: UserDefaultsKeys.distance)
            }
        }
        
        // Haptic feedback for Distance button
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapTimeFormatView() {
        if timeFormatIsDefault == true {
            firstBlock.timeFormat.switchViewLeadingAnchor?.isActive = false
            firstBlock.timeFormat.switchViewTrailingAnhor?.isActive = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.timeFormat.valuesView.layoutIfNeeded()
                self?.timeFormatIsDefault = false
                UserDefaults.standard.set(self?.timeFormatIsDefault, forKey: UserDefaultsKeys.timeFormat)
            }
        } else {
            firstBlock.timeFormat.switchViewLeadingAnchor?.isActive = true
            firstBlock.timeFormat.switchViewTrailingAnhor?.isActive = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.firstBlock.timeFormat.valuesView.layoutIfNeeded()
                self?.timeFormatIsDefault = true
                UserDefaults.standard.set(self?.timeFormatIsDefault, forKey: UserDefaultsKeys.timeFormat)
            }
        }
        
        // Haptic feedback for Time Format button
        hapticFeedback.notificationOccurred(.success)
    }
    
    // MARK: - Private Functions
    private func setupScrollView() {
        view.backgroundColor = SettingsColors.backgroungWhite
        
        view.addSubview(reusableMainScrollView.scrollView)
        
        reusableMainScrollView.contentViewHeightAnchor?.constant = 734
        
        NSLayoutConstraint.activate([
            reusableMainScrollView.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            reusableMainScrollView.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reusableMainScrollView.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reusableMainScrollView.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupBlocks() {
        reusableMainScrollView.contentView.addSubview(firstBlock)
        reusableMainScrollView.contentView.addSubview(secondBlock.collectionView)
        
        NSLayoutConstraint.activate([
            firstBlock.mainView.topAnchor.constraint(equalTo: reusableMainScrollView.contentView.topAnchor, constant: 20),
            firstBlock.mainView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 0),
            firstBlock.mainView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: 0),
            firstBlock.mainView.heightAnchor.constraint(equalToConstant: 307),
            
            secondBlock.collectionView.topAnchor.constraint(equalTo: firstBlock.mainView.bottomAnchor, constant: 150),
            secondBlock.collectionView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 0),
            secondBlock.collectionView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: 0),
        ])
        
        secondBlock.collectionView.delegate = self
        secondBlock.collectionView.dataSource = self
        
        setupButtons()
    }
    
    private func setupButtons() {
        firstBlock.temperature.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTemperatureView)))
        firstBlock.speed.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSpeedView)))
        firstBlock.pressure.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPressureView)))
        firstBlock.precipitation.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrecipitationView)))
        firstBlock.distance.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDistanсeView)))
        firstBlock.timeFormat.settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTimeFormatView)))
    }
    
    private func setupUserDefaults() {
        let temperatureUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.temperature) as? Bool
        temperatureIsDefault = temperatureUserDef ?? true
        if temperatureIsDefault {
            firstBlock.temperature.switchViewLeadingAnchor?.isActive = true
            firstBlock.temperature.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.temperature.switchViewLeadingAnchor?.isActive = false
            firstBlock.temperature.switchViewTrailingAnhor?.isActive = true
        }
        
        let speedUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.speed) as? Bool
        speedIsDefault = speedUserDef ?? true
        if speedIsDefault {
            firstBlock.speed.switchViewLeadingAnchor?.isActive = true
            firstBlock.speed.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.speed.switchViewLeadingAnchor?.isActive = false
            firstBlock.speed.switchViewTrailingAnhor?.isActive = true
        }
        
        let pressureUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.pressure) as? Bool
        pressureIsDefault = pressureUserDef ?? true
        if pressureIsDefault {
            firstBlock.pressure.switchViewLeadingAnchor?.isActive = true
            firstBlock.pressure.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.pressure.switchViewLeadingAnchor?.isActive = false
            firstBlock.pressure.switchViewTrailingAnhor?.isActive = true
        }
        
        let precipitationUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.precipitation) as? Bool
        precipitationIsDefault = precipitationUserDef ?? true
        if precipitationIsDefault {
            firstBlock.precipitation.switchViewLeadingAnchor?.isActive = true
            firstBlock.precipitation.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.precipitation.switchViewLeadingAnchor?.isActive = false
            firstBlock.precipitation.switchViewTrailingAnhor?.isActive = true
        }
        
        let distanceUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.distance) as? Bool
        distanсeIsDefault = distanceUserDef ?? true
        if distanсeIsDefault {
            firstBlock.distance.switchViewLeadingAnchor?.isActive = true
            firstBlock.distance.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.distance.switchViewLeadingAnchor?.isActive = false
            firstBlock.distance.switchViewTrailingAnhor?.isActive = true
        }
        
        let timeFormatUserDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.timeFormat) as? Bool
        timeFormatIsDefault = timeFormatUserDef ?? true
        if timeFormatIsDefault {
            firstBlock.timeFormat.switchViewLeadingAnchor?.isActive = true
            firstBlock.timeFormat.switchViewTrailingAnhor?.isActive = false
        } else {
            firstBlock.timeFormat.switchViewLeadingAnchor?.isActive = false
            firstBlock.timeFormat.switchViewTrailingAnhor?.isActive = true
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SettingsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SecondBlockModel.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = secondBlock.collectionView.dequeueReusableCell(withReuseIdentifier: ReusableSettingsButtonCell.reuseIdentifier, for: indexPath) as? ReusableSettingsButtonCell else {
            return UICollectionViewCell()
        }
        cell.setupTitle(SecondBlockModel.titleArray[indexPath.row])
        cell.setupImage(SecondBlockModel.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = AppearanceVC()
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        case 1:
            let viewController = SubscriptionVC()
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        case 2:
            let appID = 0
            let reviewURL = "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review"
            
            if let url = URL(string: reviewURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        case 3:
            let viewController = AboutVC()
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        case 4:
            sendEmail()
        default:
            break
        }
    }
}

// MARK: - Extensions
private extension SettingsVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = SettingsColors.backgroungWhite
        navigationItem.title = L10nSettings.settingsNavText
        appearance.titleTextAttributes = [
            .foregroundColor: OtherUIColors.navigationItems as Any,
            .font: UIFont(name: CustomFonts.nunitoBold, size: 26) ?? UIFont.systemFont(ofSize: 26)
        ]
        
        // Setup NavigationBar and remove bottom border
        navigationItem.standardAppearance = appearance
        
        // Disable Back button
        navigationItem.setHidesBackButton(true, animated: true)
        
        // Custom Right Button
        let backButton = UIButton()
        backButton.customNavigationButton(UIImages.backRight,
                                          OtherUIColors.navigationItems)
        let rightButton = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = rightButton
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Swipe to go back
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeBack(_:)))
        swipeBackGesture.edges = .right
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc func didSwipeBack(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            navigationController?.popViewControllerToLeftType1()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailTemplate = """
                        <p>\(L10nMailField.mailTemplateFirstSentenseText)</br>
                        \(L10nMailField.mailTemplateSecondSentenseText)</p></br>
                        <br>\(L10nMailField.mailTemplateSunnyVersionText) \(UIApplication.appVersion ?? "\(L10nMailField.mailTemplateSunnyVersionOptionalText)")</br>
                        \(L10nMailField.mailTemplateIOSVersionText) \(UIDevice.current.systemVersion)</br>
                        \(L10nMailField.mailTemplateDeviceModelVersionText) \(UIDevice.current.dc.deviceModel)</br>
            """
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Sunny App / Feedback")
            mail.setToRecipients(["nikpishchugin@gmail.com"])
            mail.setMessageBody(mailTemplate, isHTML: true)
            present(mail, animated: true)
        } else {
            print("Error sending email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
