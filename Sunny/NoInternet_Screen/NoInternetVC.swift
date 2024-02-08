//
//  NoInternetVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 20.09.2022.
//

import UIKit

class NoInternetVC: UIViewController {
    
    // MARK: - Private Properties
    private let customIntentetView = CustomIntentetView()
    
    private let currentLanguage = Locale.current.languageCode
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addGradient(SubscriptionColors.backgroundTop, SubscriptionColors.backgroundBottom)
    }
    
    // MARK: - Actions
    @objc private func didTapDeviceSettings() {
        if let url = URL(string: "App-Prefs:root=WIFI") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(customIntentetView.stackView)
        
        NSLayoutConstraint.activate([
            customIntentetView.stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            customIntentetView.stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            customIntentetView.stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customIntentetView.stackView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        customIntentetView.textLabelSecond.numberOfLines = 4
        customIntentetView.goToDeviceSettingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDeviceSettings)))
    }
}
