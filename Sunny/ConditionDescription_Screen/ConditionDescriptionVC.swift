//
//  ConditionDescriptionVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 08.06.23.
//

import UIKit

class ConditionDescriptionVC: UIViewController {
    
    // MARK: - Private Properties
    private let conditionDescriptionView = ConditionDescriptionView()
    
    // MARK: - Public Properties
    var allWeatherModel = AllWeatherModels()
    var hourlyForecastModel = HourlyForecastModel()
    
    var currentConditionModel = CurrentConditionModel()
    var currentAirPollutionModel = CurrentAirPollutionModel()
    var hourConditionModel = HourConditionModel()
    var dayConditionModel = DayConditionModel()
    
    var cellTitle = ""
    var cellValue = ""
    var currentIndex = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        navigationItem.title = cellTitle
        
        print("cellValue: \(cellValue); currentIndex: \(currentIndex)")
        
        print(currentConditionModel.parameterValueArray)
        print(hourConditionModel.parameterValueArray)
        print(dayConditionModel.parameterValueArray)
        setupUI()
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(conditionDescriptionView.mainView)
        
        NSLayoutConstraint.activate([
            conditionDescriptionView.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            conditionDescriptionView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.5),
            conditionDescriptionView.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.5),
            conditionDescriptionView.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Extensions
private extension ConditionDescriptionVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = "Condition Description"
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
        
        // Custom Left Button
        let backButton = UIButton()
        backButton.customNavigationButton(UIImages.backLeft,
                                          OnboardingColors.parametersText1)
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
