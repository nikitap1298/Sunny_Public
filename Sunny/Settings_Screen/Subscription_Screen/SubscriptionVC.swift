//
//  SubscriptionVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 06.05.23.
//

import UIKit
import RevenueCat
import SPIndicator
import UIDeviceComplete

class SubscriptionVC: UIViewController {
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    private let subscriptionView = SubscriptionView()
    private let reusableActivityView = ReusableActivityView()
    
    private var hasSubscription = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Purchases.shared.getCustomerInfo { [weak self] customer, error in
            if  customer?.entitlements[RevenueCat.entitlementPro]?.isActive == true {
                self?.subscriptionView.monthlyButton.setTitle(L10nSettings.subscriptionMonthlyButtonType2, for: .normal)
                self?.subscriptionView.monthlyButton.isEnabled = false
                self?.subscriptionView.oneWeekTrialLabel.isHidden = true
                self?.hasSubscription = true
                self?.customNavigationBar()
            } else {
                self?.fetchSubscriptionPrice { proPlanPrice, error in
                    self?.subscriptionView.monthlyButton.setTitle(proPlanPrice + L10nSettings.subscriptionMonthlyButtonType1, for: .normal)
                    self?.hasSubscription = false
                    self?.customNavigationBar()
                    
                    if (error != nil) {
                        self?.subscriptionView.monthlyButton.setTitle("$1.99" + L10nSettings.subscriptionMonthlyButtonType1, for: .normal)
                        self?.hasSubscription = false
                        self?.customNavigationBar()
                    }
                }
            }
        }
        
        view.backgroundColor = SettingsColors.backgroungWhite
        
        setupSubscriptionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        subscriptionView.mainView.addGradient(SubscriptionColors.backgroundTop, SubscriptionColors.backgroundBottom)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    @objc private func didTapMonthlyButton() {
        
        setupReusableActivityView()
        
        // RevenueCat Subscribe
        Purchases.shared.getOfferings { offerings, error in
            
            guard let package = offerings?.current?.monthly else { return }
            
            Purchases.shared.purchase(package: package) { [weak self] (transaction, customerInfo, error, userCancelled) in
                
                self?.reusableActivityView.activityIndicator.stopAnimating()
                self?.reusableActivityView.mainView.removeFromSuperview()
                
                if customerInfo?.entitlements[RevenueCat.entitlementPro]?.isActive == true {
                    self?.hapticFeedback.notificationOccurred(.success)
                    let viewController = OnboardingVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapRestorePurchases() {
        
        setupReusableActivityView()
        
        // RevenueCat Restore Purchases
        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
            
            self?.reusableActivityView.activityIndicator.stopAnimating()
            self?.reusableActivityView.mainView.removeFromSuperview()
            
            if customerInfo?.entitlements[RevenueCat.entitlementPro]?.isActive != true {
                self?.hapticFeedback.notificationOccurred(.error)
                let alert = UIAlertController(title: L10nSettings.subscriptionAlertFailedTitle, message: L10nSettings.subscriptionAlertFailedMessage, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: L10nSettings.subscriptionAlertActionTitle, style: .default) { action in }
                alert.addAction(alertAction)
                self?.present(alert, animated: true)
            } else {
                self?.hapticFeedback.notificationOccurred(.success)
                let alert = UIAlertController(title: L10nSettings.subscriptionAlertSuccessfulTitle, message: L10nSettings.subscriptionAlertSuccessfulMessage, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: L10nSettings.subscriptionAlertActionTitle, style: .default) { [weak self] action in
                    let viewController = OnboardingVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
                alert.addAction(alertAction)
                self?.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Private Functions
    private func fetchSubscriptionPrice(completion: @escaping (String, Error?) -> Void) {
        Purchases.shared.getOfferings { offering, error in
            completion(offering?.current?.monthly?.localizedPriceString ?? "$1.99", error)
        }
    }
    
    private func setupSubscriptionView() {
        view.addSubview(subscriptionView.mainView)
        
        NSLayoutConstraint.activate([
            subscriptionView.mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subscriptionView.mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subscriptionView.mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        
        switch UIDevice.current.dc.deviceModel {
        case .iPodTouchSeventhGen,
                .iPhone6S,
                .iPhone7,
                .iPhone8,
                .iPhoneSE,
                .iPhoneSE2,
                .iPhoneSE3:
            NSLayoutConstraint.activate([
                subscriptionView.mainView.heightAnchor.constraint(equalToConstant: view.frame.height / 1.5)
            ])
        default:
            NSLayoutConstraint.activate([
                subscriptionView.mainView.heightAnchor.constraint(equalToConstant: view.frame.height / 1.85)
            ])
        }
        
        subscriptionView.monthlyButton.addTarget(self, action: #selector(didTapMonthlyButton), for: .touchUpInside)
        subscriptionView.restorePurchasesButton.addTarget(self, action: #selector(didTapRestorePurchases), for: .touchUpInside)
    }
    
    private func setupReusableActivityView() {
        view.addSubview(reusableActivityView.mainView)
        
        NSLayoutConstraint.activate([
            reusableActivityView.mainView.topAnchor.constraint(equalTo: view.topAnchor),
            reusableActivityView.mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reusableActivityView.mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reusableActivityView.mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        reusableActivityView.activityIndicator.startAnimating()
    }
}

// MARK: - Extensions
private extension SubscriptionVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nSettings.subscriptionNavTitle
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
        
        if !hasSubscription {
            navigationItem.leftBarButtonItem = .none
            navigationItem.rightBarButtonItem = .none
        }
        
        // Swipe to go back
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeBack(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc func didSwipeBack(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized && hasSubscription {
            navigationController?.popViewControllerToRightType1()
        }
    }
}
