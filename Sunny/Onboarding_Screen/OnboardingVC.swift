//
//  ViewController.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 30.06.2022.
//

import UIKit
import CoreLocation
import DGCharts
import Alamofire
import SPIndicator

// MARK: - Enum DayButtonType
enum DayButtonType {
    case now
    case next10Days
}

class OnboardingVC: UIViewController, ChartViewDelegate {
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    private let currentWeatherSpace = CurrentWeatherSpace()
    private let currentWeatherView = CurrentWeatherView()
    private let reusableMainScrollView = ReusableMainScrollView()
    private let temperatureCollectionView = TemperatureCollectionView()
    private let daybuttons = DayButtons()
    private let currentConditionView = CurrentConditionView()
    private let graphView = GraphView()
    private let weatherKitView = WeatherKitView()
    private let nextTenDaysConditionView = NextTenDaysConditionView()
    
    private var weatherKitManager = WeatherKitManager()
    private var openWeatherManager = OpenWeatherManager()
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()

    private var allWeatherModel = AllWeatherModels()
    private var hourlyForecastModel = HourlyForecastModel()
    private var currentAirPollutionModel = CurrentAirPollutionModel()
    private let conditionImage = ConditionImage()
    private var conditionImageArray = [UIImage]()
    
    // Models
    private let converter = Converter()
    private let timeConverter = TimeConverter()
    private let timeModel = TimeModel()
    private var currentConditionModel = CurrentConditionModel()
    
    private var todayButtonPressed: Bool = true
    private var isCurrent: Bool = true
    
    private var latitude = 40.730
    private var longitude = -73.935
    
    // MARK: - Public Properties
    var locationTimer = Timer()
    var currentForecastTimer = Timer()
    var cityForecastTimer = Timer()
    
    // MARK: - Computed Properties
    
    // When timeZone gets a correct value, all elements change
    private var timeZone: Int? {
        didSet {
            setupGraph()
            currentConditionModel.fillView(currentWeatherView,
                                           allWeatherModel,
                                           converter,
                                           timeConverter,
                                           timeZone)
            temperatureCollectionView.collectionView.reloadData()
            nextTenDaysConditionView.collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        choosePlace()
        NotificationCenter.default.addObserver(forName: NotificationNames.updateLocation, object: nil, queue: .main) { [weak self] _ in
            self?.choosePlace()
        }
        
        locationTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { [weak self] _ in
            self?.locationManager.requestWhenInUseAuthorization()
            self?.locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        latitude = UserDefaults.standard.value(forKey: UserDefaultsKeys.currentLocationLatitude) as? Double ?? 40.730
        longitude = UserDefaults.standard.value(forKey: UserDefaultsKeys.currentLocationLongitude) as? Double ?? -73.935
        
        weatherKitManager.weatherKitManagerDelegate = self
        openWeatherManager.openWeatherManagerDelegate = self
        locationManager.delegate = self
        
        // Reload all views
        currentConditionModel.fillView(currentWeatherView,
                                       allWeatherModel,
                                       converter,
                                       timeConverter,
                                       timeZone)
        currentConditionModel.fillValueArray(allWeatherModel,
                                             converter,
                                             currentAirPollutionModel)
        currentConditionModel.fillImageArray(allWeatherModel,
                                             hourlyForecastModel,
                                             currentAirPollutionModel)
        
        temperatureCollectionView.collectionView.reloadData()
        currentConditionView.collectionView.reloadData()
        nextTenDaysConditionView.collectionView.reloadData()
        
        // Which city will be shown
        setupCurrentTemperatureView()
        setupMainScrollView()
        
        setupTemperatureCollectionView()
        setupDayButtons()
        
        if todayButtonPressed == true {
            setupNowView()
        } else {
            setupNextSevenDaysView()
        }
        
        // App Review
        AppReview.requestReviewIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        currentConditionModel.parameterValueArray.removeAll()
        currentConditionModel.parameterImageArray.removeAll()
    }
    
    // MARK: - Actions
    @objc private func didTapSettingsButton() {
        let viewController = SettingsVC()
        navigationController?.pushViewControllerFromLeftType1(controller: viewController)
    }
    
    @objc private func didTapSearchButton() {
        let viewController = SearchVC()
        viewController.searchVCDelegate = self
        viewController.latitude = latitude
        viewController.longitude = longitude
        navigationController?.pushViewControllerFromRightType1(controller: viewController)
    }
    
    @objc private func didTapOpenMap(_ sender: UITapGestureRecognizer) {
        let viewController = MapVC()
        
        if let place = currentWeatherView.cityNameLabel.text {
            viewController.place = place
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        }
    }
    
    @objc private func didTapTodayButton() {
        dayButtonsLogic(for: .now)
        hapticFeedback.notificationOccurred(.success)
    }
    
    @objc private func didTapNextSevenDaysButton() {
        dayButtonsLogic(for: .next10Days)
        hapticFeedback.notificationOccurred(.success)
    }
    
    // MARK: - ChoosePlace Function
    private func choosePlace() {
        let isCurrentDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.isCurrent) as? Bool
        isCurrent = isCurrentDef ?? true
        
        let address = UserDefaults.standard.string(forKey: UserDefaultsKeys.onboardingVCAddress)
        
        // Change .now() + time if the weather isn't loading
        if isCurrent {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
                self?.fetchWeather(self?.latitude, self?.longitude)
                print("Did update weather in the current location")
            }
        } else {
            let cityLatitude = UserDefaults.standard.value(forKey: UserDefaultsKeys.cityLatitude) as? Double
            let cityLongitude = UserDefaults.standard.value(forKey: UserDefaultsKeys.cityLongitude) as? Double
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.fetchWeather(cityLatitude, cityLongitude,  address ?? "")
                print("Did update weather in the specific location")
            }
        }
    }
    
    // MARK: - Private Functions (UI)
    
    // Fetch Weather
    private func fetchWeather(_ latitude: CLLocationDegrees?, _ longitude: CLLocationDegrees?, _ address: String = "") {
        guard let latitude = latitude,
              let longitude = longitude else { return }
        
        getAddress(latitude, longitude, address)
        
        openWeatherManager.fetchCurrentAirPollution(latitude, longitude)
        
        // Helps to display correct AirPollution in collection
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.weatherKitManager.fetchWeather(latitude, longitude)
            self?.weatherKitManager.fetchHourlyForecast(latitude, longitude)
        }
        
        // Get Timezone
        timeModel.getTimezone(latitude, longitude) { timeZone in
            self.timeZone = timeZone
        }
    }
    
    // Get Address
    private func getAddress(_ latitude: CLLocationDegrees?, _ longitude: CLLocationDegrees?, _ address: String) {
        let location = CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        location.getCityAndCountry(address: address) { [weak self] city, country, error in
            guard let city = city,
                  let country = country else {
                self?.navigationItem.title = "\(latitude ?? 0.0); \(longitude ?? 0.0)"
                self?.currentWeatherView.cityNameLabel.text = "\(latitude ?? 0.0); \(longitude ?? 0.0)"
                return
            }
            
            self?.navigationItem.title = city
            self?.currentWeatherView.cityNameLabel.text = city + ", " + country
        }
    }
    
    // CurrentTemperatureView
    private func setupCurrentTemperatureView() {
        view.addSubview(currentWeatherSpace.mainView)
        currentWeatherSpace.mainView.addSubview(currentWeatherView.mainView)
        
        NSLayoutConstraint.activate([
            currentWeatherSpace.mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            currentWeatherSpace.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currentWeatherSpace.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currentWeatherSpace.mainView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.3),
            
            currentWeatherView.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherView.mainView.leadingAnchor.constraint(equalTo: currentWeatherSpace.mainView.leadingAnchor, constant: 10),
            currentWeatherView.mainView.trailingAnchor.constraint(equalTo: currentWeatherSpace.mainView.trailingAnchor, constant: -10),
            currentWeatherView.mainView.bottomAnchor.constraint(equalTo: currentWeatherSpace.mainView.bottomAnchor, constant: 0)
        ])
        
        // Swipe to go back
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOpenMap(_:)))
        currentWeatherView.cityStackView.isUserInteractionEnabled = true
        currentWeatherView.cityStackView.addGestureRecognizer(tapGesture)
    }
    
    // ScrollView
    private func setupMainScrollView() {
        view.addSubview(reusableMainScrollView.scrollView)
        
        NSLayoutConstraint.activate([
            reusableMainScrollView.scrollView.topAnchor.constraint(equalTo: currentWeatherSpace.mainView.bottomAnchor, constant: 20),
            reusableMainScrollView.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            reusableMainScrollView.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            reusableMainScrollView.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // CollectionView
    private func setupTemperatureCollectionView() {
        reusableMainScrollView.contentView.addSubview(temperatureCollectionView.collectionView)
        
        NSLayoutConstraint.activate([
            temperatureCollectionView.collectionView.topAnchor.constraint(equalTo: reusableMainScrollView.contentView.topAnchor, constant: 0),
            temperatureCollectionView.collectionView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 0),
            temperatureCollectionView.collectionView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: 0),
            temperatureCollectionView.collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupDayButtons() {
        reusableMainScrollView.contentView.addSubview(daybuttons.stackView)
        
        NSLayoutConstraint.activate([
            daybuttons.stackView.topAnchor.constraint(equalTo: temperatureCollectionView.collectionView.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            daybuttons.stackView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 25),
            daybuttons.stackView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: -25),
            daybuttons.stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        daybuttons.todayButton.addTarget(self, action: #selector(didTapTodayButton), for: .touchUpInside)
        daybuttons.nextTenDaysButton.addTarget(self, action: #selector(didTapNextSevenDaysButton), for: .touchUpInside)
    }
    
    private func setupNowView() {
        reusableMainScrollView.contentView.addSubview(currentConditionView.collectionView)
        reusableMainScrollView.contentView.addSubview(graphView.lineChartView)
        reusableMainScrollView.contentView.addSubview(weatherKitView.horizontalStack)
        
        NSLayoutConstraint.activate([
            currentConditionView.collectionView.topAnchor.constraint(equalTo: daybuttons.stackView.bottomAnchor, constant: 20),
            currentConditionView.collectionView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 10),
            currentConditionView.collectionView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: -10),
            currentConditionView.collectionView.heightAnchor.constraint(equalToConstant: 500),
            
            graphView.lineChartView.topAnchor.constraint(equalTo: currentConditionView.collectionView.bottomAnchor, constant: 50),
            graphView.lineChartView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 10),
            graphView.lineChartView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: -10),
            graphView.lineChartView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5),
            
            weatherKitView.horizontalStack.topAnchor.constraint(equalTo: graphView.lineChartView.bottomAnchor, constant: 30),
            weatherKitView.horizontalStack.centerXAnchor.constraint(equalTo: reusableMainScrollView.contentView.centerXAnchor, constant: 0)
        ])
    }
    
    private func setupNextSevenDaysView() {
        reusableMainScrollView.contentView.addSubview(nextTenDaysConditionView.collectionView)
        
        NSLayoutConstraint.activate([
            nextTenDaysConditionView.collectionView.topAnchor.constraint(equalTo: daybuttons.stackView.bottomAnchor, constant: 20),
            nextTenDaysConditionView.collectionView.leadingAnchor.constraint(equalTo: reusableMainScrollView.contentView.leadingAnchor, constant: 10),
            nextTenDaysConditionView.collectionView.trailingAnchor.constraint(equalTo: reusableMainScrollView.contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func dayButtonsLogic(for dayButtonType: DayButtonType) {
        switch dayButtonType {
        case .now:
            daybuttons.todayButton.setTitleColor(CustomColors.colorVanilla, for: .normal)
            daybuttons.nextTenDaysButton.setTitleColor(OnboardingColors.dayButtonsUnSelected, for: .normal)
            reusableMainScrollView.contentViewHeightAnchor?.constant = Constraints.contentViewTodayHeight()
            todayButtonPressed = true
            nextTenDaysConditionView.collectionView.removeFromSuperview()
            setupNowView()
        case .next10Days:
            if allWeatherModel.temperatureMinDaily.count > 0 {
                daybuttons.todayButton.setTitleColor(OnboardingColors.dayButtonsUnSelected, for: .normal)
                daybuttons.nextTenDaysButton.setTitleColor(CustomColors.colorVanilla, for: .normal)
                reusableMainScrollView.contentViewHeightAnchor?.constant = Constraints.contentViewNextSevenDaysHeight()
                todayButtonPressed = false
                currentConditionView.collectionView.removeFromSuperview()
                graphView.lineChartView.removeFromSuperview()
                weatherKitView.horizontalStack.removeFromSuperview()
                setupNextSevenDaysView()
            } else {
                SPIndicator.present(title: "Error", message: "Try again later", preset: .error, haptic: .error)
            }
        }
    }
    
    private func setupGraph() {
        var entries = [ChartDataEntry]()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
    
            if self.hourlyForecastModel.temperatureApparent.count > 23 {
        
                for i in Ranges.next24Hours {
                    entries.append(ChartDataEntry(x: self.timeConverter.convertToSeconds(self.hourlyForecastModel.forecastStart[i], self.timeZone),
                                                  y: self.hourlyForecastModel.temperatureApparent[i]))
                }
            }

            let set1 = LineChartDataSet(entries: entries, label: L10nGraph.onboardingVCGraphText)
            set1.drawCirclesEnabled = false
            set1.mode = .cubicBezier
            set1.lineWidth = 3
            set1.setColor(CustomColors.colorBlue1 ?? .blue)
            set1.fillColor = CustomColors.colorBlue?.withAlphaComponent(1.0) ?? .blue
            set1.drawFilledEnabled = true
            
            set1.drawHorizontalHighlightIndicatorEnabled = false
            set1.highlightColor = CustomColors.colorRed ?? .systemRed
            
            let data = LineChartData(dataSet: set1)
            data.setDrawValues(false)
            
            self.graphView.lineChartView.data = data
            self.graphView.lineChartView.delegate = self
        }
    }
    
}

// MARK: - WeatherKitManagerDelegate, OpenWeatherManagerDelegate
extension OnboardingVC: WeatherKitManagerDelegate, OpenWeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherKitManager: WeatherKitManager, weather: AllWeatherModels) {
        self.allWeatherModel = weather
        
        currentConditionModel.parameterValueArray.removeAll()
        currentConditionModel.parameterImageArray.removeAll()
    
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.currentConditionModel.fillView(self.currentWeatherView,
                                                weather,
                                                self.converter,
                                                self.timeConverter,
                                                self.timeZone)
            
            self.currentConditionModel.fillValueArray(weather, self.converter, self.currentAirPollutionModel)
            self.currentConditionModel.fillImageArray(weather, self.hourlyForecastModel, self.currentAirPollutionModel)
            
            self.currentConditionView.collectionView.delegate = self
            self.currentConditionView.collectionView.dataSource = self
            self.currentConditionView.collectionView.reloadData()
        }

        nextTenDaysConditionView.collectionView.delegate = self
        nextTenDaysConditionView.collectionView.dataSource = self
        nextTenDaysConditionView.collectionView.reloadData()
        
        print("Update all weather")
    }
    
    func didUpdateHourlyForecast(_ weatherKitManager: WeatherKitManager, hourlyForecast: HourlyForecastModel) {
        self.hourlyForecastModel = hourlyForecast
        
        // Add condition images into array
        conditionImageArray.removeAll()
        for (index, condition) in hourlyForecastModel.conditionCode.enumerated() {
            conditionImageArray.append(conditionImage.weatherIcon(condition, hourlyForecastModel.daylight[index]) ?? .checkmark)
        }
        temperatureCollectionView.collectionView.delegate = self
        temperatureCollectionView.collectionView.dataSource = self
        temperatureCollectionView.collectionView.reloadData()
        
        self.setupGraph()
        
        print("Update hourly forecast")
    }
    
    func didUpdateCurrentAirPollution(_ openWeatherManager: OpenWeatherManager, currentAirPollution: CurrentAirPollutionModel) {
        self.currentAirPollutionModel = currentAirPollution
        
        print("Update current air pollution")
    }
}

// MARK: - CLLocationManagerDelegate
extension OnboardingVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        latitude = round((locations.last?.coordinate.latitude ?? 40.730) * 1000) / 1000
        longitude = round((locations.last?.coordinate.longitude ?? -73.935) * 1000) / 1000
        
        // Save latitude & longitude in UserDefaults because then currentLocation always appears in SearchVC
        UserDefaults.standard.set(latitude, forKey: UserDefaultsKeys.currentLocationLatitude)
        UserDefaults.standard.set(longitude, forKey: UserDefaultsKeys.currentLocationLongitude)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.temperatureCollectionView.collectionView {
            return hourlyForecastModel.temperature[Ranges.next24Hours].count
        } else if collectionView == self.currentConditionView.collectionView {
            return currentConditionModel.parameterValueArray.count
        } else if collectionView == self.nextTenDaysConditionView.collectionView {
            return allWeatherModel.temperatureMinDaily[Ranges.next10Days].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Temperature CollectionView
        if collectionView == temperatureCollectionView.collectionView {
            guard let cell = temperatureCollectionView.collectionView.dequeueReusableCell(withReuseIdentifier: CustomTemperatureCollectionCell.reuseIdentifier, for: indexPath) as? CustomTemperatureCollectionCell else {
                return UICollectionViewCell()
            }
            
            let conditionImage = self.conditionImageArray[indexPath.row + 1]
            let time = timeConverter.convertToHoursMinutes(hourlyForecastModel.forecastStart[indexPath.row + 1], timeZone)
            let temperature = converter.convertTemperature(hourlyForecastModel.temperature[indexPath.row + 1])
            
            cell.setupCollectionCellValues(condImage: conditionImage, time: time, temperature: temperature)
            return cell
        }
        
        // Today ConditionView
        if collectionView == currentConditionView.collectionView {
            guard let cell = currentConditionView.collectionView.dequeueReusableCell(withReuseIdentifier: CurrentConditionCell.reuseIdentifier, for: indexPath) as? CurrentConditionCell else {
                return UICollectionViewCell()
            }
            
            let conditionName = currentConditionModel.parameterNameArray[indexPath.row]
            cell.setupConditionNameLabel(conditionName)
            
            if currentConditionModel.parameterValueArray.count >= 7 && currentConditionModel.parameterImageArray.count >= 7 {
                let conditionValue = currentConditionModel.parameterValueArray[indexPath.row]
                let conditionImage = currentConditionModel.parameterImageArray[indexPath.row]
                cell.setupConditionValueLabel(conditionValue)
                cell.setupConditionImage(conditionImage)
            }
            return cell
        }
        
        // NextSevenDays ConditionView
        if collectionView == nextTenDaysConditionView.collectionView {
            guard let cell = nextTenDaysConditionView.collectionView.dequeueReusableCell(withReuseIdentifier: NextSevenDaysConditionCell.reuseIdentifier, for: indexPath) as? NextSevenDaysConditionCell else {
                return UICollectionViewCell()
            }
            
            let date = timeConverter.convertToDayNumber(allWeatherModel.forecastStartDaily[indexPath.row], timeZone)
            let temperatureMin = converter.convertTemperature(allWeatherModel.temperatureMinDaily[indexPath.row])
            let temperatureMax = converter.convertTemperature(allWeatherModel.temperatureMaxDaily[indexPath.row])
            let conditionImage = conditionImage.weatherIcon(allWeatherModel.conditionCodeDaily[indexPath.row], true)
            
            if indexPath.row == 0 {
                cell.setupDate(L10nOnboarding.todayButtonText)
            } else {
                cell.setupDate(date)
            }
            cell.setupTemperatureLabel(temperatureMin, temperatureMax)
            cell.setupConditionImage(conditionImage)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Open HourVC after user tap cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tappedCell = collectionView.cellForItem(at: indexPath) as? CustomTemperatureCollectionCell  {
            let viewController = HourVC()
            viewController.hourlyForecastModel = hourlyForecastModel
            viewController.cellDate = tappedCell.timeLabel.text ?? "Time"
            viewController.currentIndex = indexPath.row
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        } else if let tappedCell1 = collectionView.cellForItem(at: indexPath) as? CurrentConditionCell {
            let viewController = ConditionDescriptionVC()
            viewController.allWeatherModel = allWeatherModel
            viewController.cellTitle = tappedCell1.parameterNameLabel.text ?? "Title"
            viewController.cellValue = tappedCell1.parameterValueLabel.text ?? "-"
            viewController.currentIndex = indexPath.row
            viewController.currentConditionModel = currentConditionModel
            viewController.currentAirPollutionModel = currentAirPollutionModel
//            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        } else if let tappedCell2 = collectionView.cellForItem(at: indexPath) as? NextSevenDaysConditionCell {
            let viewController = DayVC()
            viewController.allWeatherModel = allWeatherModel
            viewController.cellDate = tappedCell2.dateLabel.text ?? "Day"
            viewController.currentIndex = indexPath.row
            viewController.timeZone = timeZone ?? 0
            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        }
    }
    
}

// MARK: - SearchVCDelegate
extension OnboardingVC: SearchVCDelegate {
    
    func didSendCoordinates(_ latitude: String, _ longitude: String, _ adress: String) {
        currentForecastTimer.invalidate()
        
        let doubleLatitude = (latitude as NSString).doubleValue
        let doubleLongitude = (longitude as NSString).doubleValue
        
        UserDefaults.standard.set(doubleLatitude, forKey: UserDefaultsKeys.cityLatitude)
        UserDefaults.standard.set(doubleLongitude, forKey: UserDefaultsKeys.cityLongitude)
        UserDefaults.standard.set(adress, forKey: UserDefaultsKeys.onboardingVCAddress)
        
        fetchWeather(doubleLatitude, doubleLongitude, adress)
    }
}

// MARK: - OnboardingViewController
extension OnboardingVC {
    
    // This method helps to change appearance inside the app if the system appearance of the phone changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            
        }
    }
    
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nOnboarding.onboardingNavText
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
        let settingsButton = UIButton()
        settingsButton.customNavigationButton(UIImages.settings,
                                              OnboardingColors.parametersText1)
        let leftButton = UIBarButtonItem(customView: settingsButton)
        navigationItem.leftBarButtonItem = leftButton
        
        // Custom Right Button
        let searchButton = UIButton()
        searchButton.customNavigationButton(UIImages.search,
                                            OnboardingColors.parametersText1)
        let rightButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = rightButton
        
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
}
