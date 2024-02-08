//
//  MainVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 10.06.23.
//

import UIKit
import Network
import RevenueCat

class MainVC: UIViewController {
    
    // MARK: - Private Properties
    private let internetMonitor = NWPathMonitor()
    private let internetQueue = DispatchQueue(label: "InternetConnectionMonitor")
    
    // Properties for tutorial screen
    private var initialLaunch: Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
        showTutorialScreen()
        
        view.backgroundColor = SettingsColors.backgroungWhite
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Purchases.shared.getCustomerInfo { [weak self] customer, error in
            
            if self?.initialLaunch == false {
                if customer?.entitlements[RevenueCat.entitlementPro]?.isActive == true {
                    print("Subscription is Active")
                    let viewController = OnboardingVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                } else if customer?.entitlements[RevenueCat.entitlementPro]?.isActive != true && self?.initialLaunch == false {
                    print("Decline")
                    let viewController = SubscriptionVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Private Functions
    private func checkInternetConnection() {
        internetMonitor.pathUpdateHandler = { pathHandler in
            if pathHandler.status == .satisfied {
                print("Internet connection is on")
            } else {
                DispatchQueue.main.async { [weak self] in
                    let viewController = NoInternetVC()
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.modalTransitionStyle = .coverVertical
                    self?.present(viewController, animated: true)
                }
            }
        }
        
        internetMonitor.start(queue: internetQueue)
    }
    
    // Check initial launch
    private func showTutorialScreen() {
        let initialLaunchIsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.initialLaunch) as? Bool
        
        initialLaunch = initialLaunchIsDef ?? true
        
        if initialLaunch {
            DispatchQueue.main.async { [weak self] in
                let viewController = TutorialVC()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

// MARK: - Extensions
private extension MainVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = ""
        appearance.titleTextAttributes = [
            .foregroundColor: OnboardingColors.parametersText1 as Any,
            .font: UIFont(name: CustomFonts.nunitoBold, size: 26) ?? UIFont.systemFont(ofSize: 26)
        ]
        
        // Setup NavigationBar and remove bottom border
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Disable Back button
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc func didSwipeBack(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            navigationController?.popViewControllerToLeftType1()
        }
    }
}
