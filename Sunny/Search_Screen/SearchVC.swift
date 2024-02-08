//
//  SearchViewController.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 21.07.2022.
//

import UIKit
import CoreLocation
import SwipeCellKit
import SPIndicator
import MapKit
import RealmSwift

// MARK: - Protocols
protocol SearchVCDelegate: AnyObject {
    func didSendCoordinates(_ latitude: String, _ longitude: String, _ address: String)
}

// MARK: - View Controller
class SearchVC: UIViewController {
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    private let offSetValue: CGFloat = 20
    
    private let textView = TextView()
    private var textViewBottomAnchor: NSLayoutConstraint?
    private let searchCollectionView = SearchCollectionView()
    private let reusableActivityView = ReusableActivityView()
    
    private var weatherKitManager = WeatherKitManager()
    private let locationManager = CLLocationManager()
    private let location = CLLocation()
    
    // City Search
    private let cityAutoComplete = CityAutoComplete()
    private let autoCompleteTableView = AutoCompleteView()
    
    private var alertController = UIAlertController()
    private let customAccessoryView = CustomAccessoryView()
    
    // Models
    private var cellModel = CellModel()
    private let weatherDescription = WeatherDescription()
    private let conditionImage = ConditionImage()
    
    private var currentCity = City()
    
    private let converter = Converter()
    
    // isCurrent is true if user press current location weather
    private var isCurrent: Bool = true
    
    // locationServicesAreEnable = true if location services are enable
    private var locationServicesAreEnable: Bool = true
    
    private var coordinatesMode: Bool = false
    private var numberOfKeyboardAppears: Int = 0
    
    // Realm
    // configuration - Migration
    private let realm = try! Realm(configuration: Realm.Configuration(
        schemaVersion: 2, // Increment the schema version
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                // Perform the migration
                migration.enumerateObjects(ofType: City.className()) { oldObject, newObject in
                    // Set the default value for the new property
                    newObject?["explorerMode"] = false
                }
            }
        }))
    private let cities = try! Realm().objects(City.self)
    private var placeNeedUpdate: Bool = false
    private var temperatureButtonChange: Bool?
    private var allowUpdateDBUsingWeatherKit: Bool?
    private var numberOfPlacesInDB = 0
    
    private var loadCurrentLocation: Bool = true {
        didSet {
            if temperatureButtonChange == true || allowUpdateDBUsingWeatherKit == true {
                
                if cities.count == 0 {
                    reusableActivityView.activityIndicator.stopAnimating()
                    reusableActivityView.mainView.removeFromSuperview()
                } else {
                    placeNeedUpdate = true
                }
//                print(currentCity.temperature)
                
                for city in cities {
                    weatherKitManager.fetchWeather(city.latitude, city.longitude)
                    
                    // 0.8 second delay which helps to correctly update database
                    usleep(700_000)
                    
                    print("Update places weather using WeatherKit")
                }
            } else if temperatureButtonChange == false && allowUpdateDBUsingWeatherKit == false {
                DispatchQueue.main.async { [weak self] in
                    self?.reusableActivityView.activityIndicator.stopAnimating()
                    self?.reusableActivityView.mainView.removeFromSuperview()
                }
            }
        }
    }
    
    // After the last place added in the array, the cells will update
    private var updatedPlaces: [City?] = [] {
        didSet {
            for (index, city) in self.cities.enumerated() {
                let cityToUpdate = city
                
                if self.updatedPlaces.count == self.cities.count {
                    
                    if self.updatedPlaces[index]?.latitude == city.latitude {
                        do {
                            try self.realm.write {
                                cityToUpdate.conditionDescription = self.updatedPlaces[index]?.conditionDescription ?? ""
                                cityToUpdate.temperature = self.updatedPlaces[index]?.temperature ?? ""
                                cityToUpdate.conditionCode = self.updatedPlaces[index]?.conditionCode ?? ""
                                cityToUpdate.dayLight = self.updatedPlaces[index]?.dayLight ?? true
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.numberOfPlacesInDB += 1
                    }
                }
            }
            if numberOfPlacesInDB == updatedPlaces.count {
                placeNeedUpdate = false
                
                reusableActivityView.activityIndicator.stopAnimating()
                reusableActivityView.mainView.removeFromSuperview()
            }
        }
    }
 
    // MARK: - Public Properties
    weak var searchVCDelegate: SearchVCDelegate?
    
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        checkLocationService()
        
        weatherKitManager.weatherKitManagerDelegate = self
    
        DispatchQueue.main.async { [weak self] in
            self?.loadCurrentLocationAndUpdateDB()
        }
        
        cityAutoComplete.searchCompleter.delegate = self
        cityAutoComplete.searchCompleter.region = MKCoordinateRegion(.world)
        cityAutoComplete.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        
        setupUI()
        registerForKeyboardNotifications()
        setupReusableActivityView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.temperatureButtonChange)
        
        /*
         allowUpdateDBUsingWeatherKit will be false next time user open SearchVC.
         If he/she will restart the app then allowUpdateDBUsingWeatherKit will be true.
        */
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.allowUpdateDBUsingWeatherKit)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    @objc private func didTapCoordinatesButton() {
        coordinatesAlert()
    }
    
    @objc private func didTapCancelButton(_ sender: UISwipeGestureRecognizer) {
        textView.searchTextField.text = ""
        view.endEditing(true)
    }
    
    @objc private func minusButtonTapped() {
        if let textField = alertController.textFields?.first(where: { $0.isFirstResponder }) {
            textField.insertText("-")
        }
    }
    
    // MARK: - Private Functions
    
    // Check Location Services accessibility
    private func checkLocationService() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            guard let self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.loadCurrentLocation = false
                    self.locationServicesAreEnable = false
                case .authorizedAlways, .authorizedWhenInUse:
                    self.loadCurrentLocation = true
                    self.locationServicesAreEnable = true
                @unknown default:
                    self.loadCurrentLocation = false
                    self.locationServicesAreEnable = false
                }
            }
        }
    }
    
    // Get Coordinates
    private func getCoordinates(_ address: String) {
        location.getCoordinates(address: address) { [weak self] latitude, longitude in
            self?.fetchWeatherWithCoordinates(latitude, longitude, address)
        }
    }
    
    // Fetch Weather With Coordinates
    private func fetchWeatherWithCoordinates(_ latitude: CLLocationDegrees?, _ longitude: CLLocationDegrees?, _ address: String = "") {
        let location = CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        
        location.getCityAndCountry(address: address) { [weak self] city, country, error in
            
            guard let city = city,
                  let country = country else {
                self?.reusableActivityView.activityIndicator.stopAnimating()
                self?.reusableActivityView.mainView.removeFromSuperview()
                
                SPIndicator.present(title: L10nSearch.placeNotFoundTitle, preset: .error, haptic: .error)
                return
            }
            
            self?.cellModel.city = city
            self?.cellModel.countryCode = country
            self?.cellModel.latitude = latitude ?? 0.0
            self?.cellModel.longitude = longitude ?? 0.0
            self?.cellModel.explorerMode = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.weatherKitManager.fetchWeather(latitude ?? 0.0, longitude ?? 0.0)
            }
        }
    }
    
    // Update values in Database
    private func loadCurrentLocationAndUpdateDB() {
    
        let allowUpdateDBIsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.allowUpdateDBUsingWeatherKit) as? Bool
        allowUpdateDBUsingWeatherKit = allowUpdateDBIsDef ?? false
        
        let temperatureButtonIsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.temperatureButtonChange) as? Bool
        temperatureButtonChange = temperatureButtonIsDef ?? false
        
        if loadCurrentLocation {
            fetchWeatherWithCoordinates(latitude, longitude)
        } else if !locationServicesAreEnable && cities.count != 0 {
            if temperatureButtonChange == true || allowUpdateDBUsingWeatherKit == true {
                
                placeNeedUpdate = true
                
                for city in cities {
                    weatherKitManager.fetchWeather(city.latitude, city.longitude)
                    
                    // 0.8 second delay which helps to correctly update database
                    usleep(700_000)
                    
                    print("Update places weather using WeatherKit")
                }
            } else {
                reusableActivityView.activityIndicator.stopAnimating()
                reusableActivityView.mainView.removeFromSuperview()
            }
        } else if !locationServicesAreEnable && cities.count == 0 {
            reusableActivityView.activityIndicator.stopAnimating()
            reusableActivityView.mainView.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        view.addSubview(textView.mainView)
        view.addSubview(searchCollectionView.collectionView)
        
        textView.searchTextField.delegate = self
        searchCollectionView.collectionView.delegate = self
        searchCollectionView.collectionView.dataSource = self
        
        autoCompleteTableView.tableView.delegate = self
        autoCompleteTableView.tableView.dataSource = self
        
        textViewBottomAnchor = textView.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offSetValue)
        
        NSLayoutConstraint.activate([
            textView.mainView.heightAnchor.constraint(equalToConstant: 45),
            textView.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            searchCollectionView.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchCollectionView.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchCollectionView.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            searchCollectionView.collectionView.bottomAnchor.constraint(equalTo: textView.mainView.topAnchor, constant: -20)
        ])
        if UIDevice.current.dc.deviceModel == .iPodTouchSeventhGen {
            NSLayoutConstraint.activate([
                textView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
            ])
        } else {
            NSLayoutConstraint.activate([
                textView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            ])
        }
        
        guard let searchViewBottomAnchor = textViewBottomAnchor else {
            return
        }
        
        searchViewBottomAnchor.isActive = true
        
        textView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func setupAutoCompleteTableView() {
        view.addSubview(autoCompleteTableView.tableView)
        
        NSLayoutConstraint.activate([
            autoCompleteTableView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            autoCompleteTableView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            autoCompleteTableView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            autoCompleteTableView.tableView.bottomAnchor.constraint(equalTo: textView.mainView.topAnchor, constant: -20)
        ])
    }
    
    private func registerForKeyboardNotifications() {
        let showNotification = UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(forName: showNotification, object: nil, queue: .main) { [weak self] notification in
            guard let keyBoardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.textViewBottomAnchor?.constant = -(keyBoardSize.height + 10.0 )
            self?.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self?.numberOfKeyboardAppears += 1
            
            UIView.animate(withDuration: 0) {
                self?.view.layoutIfNeeded()
            } completion: { _ in
                
                if self?.coordinatesMode == false {
                    self?.setupAutoCompleteTableView()
                } else {
                    if self?.numberOfKeyboardAppears == 1 {
                        self?.view.addBlurView(style: .dark)
                    }
                }
            }
        }
        
        let hideNotification = UIResponder.keyboardWillHideNotification
        NotificationCenter.default.addObserver(forName: hideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.view.removeBlur()
            self?.numberOfKeyboardAppears = 0
            
            self?.textViewBottomAnchor?.constant = -(self?.offSetValue ?? 20.0)
            self?.navigationController?.setNavigationBarHidden(false, animated: true)
            
            // Bug with tableView dissapearing might be because of this!
            self?.autoCompleteTableView.tableView.removeFromSuperview()
            
            UIView.animate(withDuration: 3.0) {
                self?.view.layoutIfNeeded()
            }
        }
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
    
    private func coordinatesAlert() {
        coordinatesMode = true
        
        self.alertController = UIAlertController(title: L10nSearch.coordinatesAlertTitle, message: nil, preferredStyle: .alert)
        
        let titleFont = UIFont(name: CustomFonts.nunitoSemiBold, size: 20) ?? .boldSystemFont(ofSize: 20)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        
        let attributedTitle = NSAttributedString(string: L10nSearch.coordinatesAlertTitle, attributes: titleAttributes)
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        
        alertController.addTextField { textField in
            textField.font = UIFont(name: CustomFonts.nunitoRegular, size: 15)
            textField.placeholder = L10nSearch.coordinatesAlertLatitude
            textField.keyboardType = .decimalPad
            textField.inputAccessoryView = self.customAccessoryView.accessoryView
        }
        
        alertController.addTextField { textField in
            textField.font = UIFont(name: CustomFonts.nunitoRegular, size: 15)
            textField.placeholder = L10nSearch.coordinatesAlertLongitude
            textField.keyboardType = .decimalPad
            textField.inputAccessoryView = self.customAccessoryView.accessoryView
        }
        
        let searchAction = UIAlertAction(title: L10nSearch.coordinatesAlertOk, style: .default) { [weak self] _ in
            self?.coordinatesMode = false
            
            guard let latitudeTextField = self?.alertController.textFields?[0],
                  let longitudeTextField = self?.alertController.textFields?[1],
                  let latitude = latitudeTextField.text,
                  let longitude = longitudeTextField.text else { return }
            
            // Process the entered details
            let lat = Double(latitude.replacingOccurrences(of: ",", with: "."))
            let long = Double(longitude.replacingOccurrences(of: ",", with: "."))
            
            guard let lat = lat,
                  let long = long else { return }
        
            if (lat >= -90 && lat <= 90) && (long >= -180 && long <= 180) {
                self?.setupReusableActivityView()
                self?.cellModel.latitude = lat
                self?.cellModel.longitude = long
                self?.cellModel.explorerMode = true
                
                self?.weatherKitManager.fetchWeather(lat, long)
            }
        }
        
        let cancelAction = UIAlertAction(title: L10nSearch.coordinatesAlertCancel, style: .destructive) { [weak self] _ in
            self?.coordinatesMode = false
        }
        
        customAccessoryView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        alertController.addAction(cancelAction)
        alertController.addAction(searchAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - WeatherKitManagerDelegate
extension SearchVC: WeatherKitManagerDelegate {
    
    func didUpdateWeather(_ weatherKitManager: WeatherKitManager, weather: AllWeatherModels) {
        
        let requestedCity = City(name: "\(cellModel.city), \(cellModel.countryCode)",
                                 conditionDescription: weatherDescription.condition(weather.conditionCodeCurrent) ?? "",
                                 temperature: converter.convertTemperature(weather.temperatureCurrent ?? 0.0),
                                 conditionImage: conditionImage.weatherIcon(weather.conditionCodeCurrent, weather.daylightCurrent),
                                 conditionCode: weather.conditionCodeCurrent,
                                 dayLight: weather.daylightCurrent,
                                 latitude: weather.latitudeCurrent,
                                 longitude: weather.longitudeCurrent,
                                 explorerMode: cellModel.explorerMode)
        
        // The logic of how to add new place of show existing place
        if loadCurrentLocation == true && placeNeedUpdate == false  {
            currentCity = requestedCity
            if currentCity.name != "" {
                loadCurrentLocation = false
            }
        } else if !placeNeedUpdate && cities.map({ $0.latitude }).contains(requestedCity.latitude) && cities.map({ $0.longitude }).contains(requestedCity.longitude) {
            reusableActivityView.activityIndicator.stopAnimating()
            reusableActivityView.mainView.removeFromSuperview()
            SPIndicator.present(title: L10nSearch.addedCityText, preset: .error, haptic: .error)
        } else if !placeNeedUpdate && cities.count >= 5 {
            reusableActivityView.activityIndicator.stopAnimating()
            reusableActivityView.mainView.removeFromSuperview()
            SPIndicator.present(title: L10nSearch.limitReachedText, preset: .error, haptic: .error)
        } else if !loadCurrentLocation && placeNeedUpdate == false {
            do {
                reusableActivityView.activityIndicator.stopAnimating()
                reusableActivityView.mainView.removeFromSuperview()
                try realm.write {
                    realm.add(requestedCity)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else if placeNeedUpdate {
            updatedPlaces.append(requestedCity)
        }
        searchCollectionView.collectionView.reloadData()
    }
}

// MARK: - UISearchTextFieldDelegate
extension SearchVC: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isCurrent = false
        
        cityAutoComplete.searchCompleter.queryFragment = textField.text ?? ""
        // Table does not update without this line!
        autoCompleteTableView.tableView.reloadData()
//        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch traitCollection.userInterfaceStyle {
        case .light:
            view.addBlurView(style: .systemUltraThinMaterialDark)
        default:
            view.addBlurView(style: .systemThinMaterialDark)
        }
        view.bringSubviewToFront(self.textView.mainView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textView.searchTextField.text = ""
        view.removeBlur()
        cityAutoComplete.placeArray.removeAll()
        autoCompleteTableView.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityAutoComplete.placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomAutoCompleteCell.identifier, for: indexPath) as? CustomAutoCompleteCell else {
            return UITableViewCell()
        }
        cell.fillPlaceLabel(cityAutoComplete.placeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tappedCell = tableView.cellForRow(at: indexPath) as? CustomAutoCompleteCell else {
            return
        }
        view.endEditing(true)
        let place = tappedCell.placeLabel.text ?? ""
        
        setupReusableActivityView()
        getCoordinates(place)
        
        DispatchQueue.main.async { [weak self] in
            self?.autoCompleteTableView.tableView.removeFromSuperview()
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension SearchVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchResults = cityAutoComplete.getCityList(results: completer.results)
        
        for i in 0..<searchResults.count {
            
            // Next 4 lines of code help to format street etc. into the city and country
            cityAutoComplete.searchRequest.naturalLanguageQuery = "\(searchResults[i].city), \(searchResults[i].country)"
            cityAutoComplete.searchRequest.region = MKCoordinateRegion.init(.world)
            cityAutoComplete.searchRequest.resultTypes = MKLocalSearch.ResultType.address
            cityAutoComplete.getPlaces(tableView: autoCompleteTableView.tableView)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentCity.name == "" {
            return cities.count
        } else {
            return cities.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollectionView.collectionView.dequeueReusableCell(withReuseIdentifier: CustomSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        if indexPath.row == 0 && currentCity.name != "" {
            cell.setupCity(L10nSearch.currentLocationCell)
            cell.setupDescription(currentCity.conditionDescription)
            cell.setupTemperature(currentCity.temperature)
            cell.setupConditionImage(currentCity.conditionImage)
            cell.setupLatitude(currentCity.latitude)
            cell.setupLongitude(currentCity.longitude)
        } else if currentCity.name == ""  {
            if cities[indexPath.row].explorerMode == true {
                cell.setupCity("\(cities[indexPath.row].latitude); \(cities[indexPath.row].longitude)")
            } else {
                cell.setupCity(cities[indexPath.row].name)
            }
            cell.setupDescription(cities[indexPath.row].conditionDescription)
            cell.setupTemperature(cities[indexPath.row].temperature)
            cell.setupConditionImage(conditionImage.weatherIcon(cities[indexPath.row].conditionCode, cities[indexPath.row].dayLight))
            cell.setupLatitude(cities[indexPath.row].latitude)
            cell.setupLongitude(cities[indexPath.row].longitude)
        } else {
            if cities[indexPath.row - 1].explorerMode == true {
                cell.setupCity("\(cities[indexPath.row - 1].latitude); \(cities[indexPath.row - 1].longitude)")
            } else {
                cell.setupCity(cities[indexPath.row - 1].name)
            }
            cell.setupDescription(cities[indexPath.row - 1].conditionDescription)
            cell.setupTemperature(cities[indexPath.row - 1].temperature)
            cell.setupConditionImage(conditionImage.weatherIcon(cities[indexPath.row - 1].conditionCode, cities[indexPath.row - 1].dayLight))
            cell.setupLatitude(cities[indexPath.row - 1].latitude)
            cell.setupLongitude(cities[indexPath.row - 1].longitude)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tappedCell = collectionView.cellForItem(at: indexPath) as? CustomSearchCollectionViewCell else {
            return
        }
        
        let roundLatitude = Double(round(self.latitude * 1000) / 1000)
        
        if indexPath.row == 0 && currentCity.latitude == roundLatitude && currentCity.latitude != 0 {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCurrent)
        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCurrent)
        }
        searchVCDelegate?.didSendCoordinates(tappedCell.latitudeLabel.text ?? "", tappedCell.longitudeLabel.text ?? "", tappedCell.cityLabel.text ?? "")
        navigationController?.popViewControllerToRightType1()
    }
}

// MARK: - SwipeCollectionViewCellDelegate
extension SearchVC: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // User can't delete first city
        if indexPath.row != 0 && locationServicesAreEnable {
            
            let deleteAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
                // handle action by updating model with deletion
                guard let self else { return }
                
                let cityToDelete = self.cities[indexPath.row - 1]
                do {
                    try self.realm.write {
                        self.realm.delete(cityToDelete)
                    }
                    self.hapticFeedback.notificationOccurred(.success)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // For custom deleteAction
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
            
            // customize the action appearance
            deleteAction.backgroundColor = .clear
            
            deleteAction.image =  UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(CustomColors.colorVanilla ?? .white, renderingMode: .alwaysTemplate).addBackgroundCircle(CustomColors.colorRed)
            deleteAction.font = UIFont(name: CustomFonts.nunitoMedium, size: 17.5)
            deleteAction.textColor = CustomColors.colorGray
            
            return [deleteAction]
        } else if !locationServicesAreEnable {
            let deleteAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
                // handle action by updating model with deletion
                guard let self else { return }
                
                let cityToDelete = self.cities[indexPath.row]
                do {
                    try self.realm.write {
                        self.realm.delete(cityToDelete)
                    }
                    self.hapticFeedback.notificationOccurred(.success)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // For custom deleteAction
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
            
            // customize the action appearance
            deleteAction.backgroundColor = .clear
            
            deleteAction.image =  UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(CustomColors.colorVanilla ?? .white, renderingMode: .alwaysTemplate).addBackgroundCircle(CustomColors.colorRed)
            deleteAction.font = UIFont(name: CustomFonts.nunitoMedium, size: 17.5)
            deleteAction.textColor = CustomColors.colorGray
            
            return [deleteAction]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}

// MARK: - SearchViewController
private extension SearchVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nSearch.searchNavText
        appearance.titleTextAttributes = [
            .foregroundColor: OnboardingColors.parametersText1 as Any,
            .font: UIFont(name: CustomFonts.nunitoBold, size: 26) ?? UIFont.systemFont(ofSize: 26)
        ]
        
        // Setup NavigationBar and remove bottom border
        navigationItem.standardAppearance = appearance
        
        // Disable Back button
        navigationItem.setHidesBackButton(true, animated: true)
        
        // Custom Left Button
        let backButton = UIButton()
        backButton.customNavigationButton(UIImages.backLeft,
                                          OnboardingColors.parametersText1)
        let leftButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButton
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Custom Right Button
        let coordinatesButton = UIButton()
        coordinatesButton.customNavigationButton(UIImages.location_3,
                                                 OnboardingColors.parametersText1)
        let rightButton = UIBarButtonItem(customView: coordinatesButton)
        navigationItem.rightBarButtonItem = rightButton
        coordinatesButton.addTarget(self, action: #selector(didTapCoordinatesButton), for: .touchUpInside)
        
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

