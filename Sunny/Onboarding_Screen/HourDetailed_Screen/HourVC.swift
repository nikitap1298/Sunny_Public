//
//  DetailedForecastViewController.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.08.2022.
//

import UIKit

class HourVC: UIViewController {
    
    // MARK: - Private Properties
    
    // Model
    private let converter = Converter()
    private let timeConverter = TimeConverter()
    
    private let reusableMainScrollView = ReusableMainScrollView()
    private let hourConditionView = HourConditionView()
    
    private var hourConditionModel = HourConditionModel()
    
    // MARK: - Public Properties
    var hourlyForecastModel = HourlyForecastModel()
    var cellDate = ""
    var currentIndex = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        navigationItem.title = cellDate
        
        hourConditionModel.fillImageArray(data: hourlyForecastModel, currentIndex: currentIndex)
        hourConditionModel.fillValueArray(data: hourlyForecastModel, currentIndex: currentIndex)
        
        setupMainScrollView()
        setupDetailedConditionView()
        
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    // MARK: - Private Functions
    private func setupMainScrollView() {
        view.addSubview(reusableMainScrollView.scrollView)
        
        reusableMainScrollView.scrollView.isScrollEnabled = false
        reusableMainScrollView.contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            reusableMainScrollView.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            reusableMainScrollView.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            reusableMainScrollView.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            reusableMainScrollView.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1)
        ])
    }
    
    private func setupDetailedConditionView() {
        reusableMainScrollView.contentView.addSubview(hourConditionView.collectionView)
        
        NSLayoutConstraint.activate([
            hourConditionView.collectionView.topAnchor.constraint(equalTo: reusableMainScrollView.contentView.topAnchor, constant: 20),
            hourConditionView.collectionView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 5),
            hourConditionView.collectionView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: -5),
            hourConditionView.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 14)
        ])
        
        hourConditionView.collectionView.delegate = self
        hourConditionView.collectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HourVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourConditionModel.parameterValueArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourConditionView.collectionView.dequeueReusableCell(withReuseIdentifier: ReusableConditionalSquareViewCell.reuseIdentifier, for: indexPath) as? ReusableConditionalSquareViewCell else {
            return UICollectionViewCell()
        }

        cell.setupParameterName(hourConditionModel.parameterNameArray[indexPath.row])
        cell.setupParameterImage(hourConditionModel.parameterImageArray[indexPath.row])
        cell.setupParameterValue(hourConditionModel.parameterValueArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tappedCell = collectionView.cellForItem(at: indexPath) as? ReusableConditionalSquareViewCell  {
            let viewController = ConditionDescriptionVC()
            viewController.hourlyForecastModel = hourlyForecastModel
            viewController.cellTitle = tappedCell.parameterNameLabel.text ?? "Title"
            viewController.cellValue = tappedCell.parameterValueLabel.text ?? "-"
            viewController.currentIndex = indexPath.row
            viewController.hourConditionModel = hourConditionModel
//            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        }
    }
}

// MARK: - HourVC
private extension HourVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = "Day"
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
