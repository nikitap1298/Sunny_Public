//
//  MapVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 31.08.23.
//

import UIKit
import MapKit
import RealmSwift

enum MapType: String, CaseIterable {
    case hybrid = "Hybrid"
    case satellite = "Satellite"
    case mutedStandard = "Muted Standard"
    case standart = "Standart"
    
    var mkMapType: MKMapType {
        switch self {
        case .hybrid:
            return .hybrid
        case .satellite:
            return .satellite
        case .mutedStandard:
            return .mutedStandard
        case .standart:
            return .standard
        }
    }
}

class MapVC: UIViewController {
    
    // MARK: - Private Properties
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
    private let safeAreaGhostView = UIView()
    private let mapView = MapView()
    private var location = CLLocation()
    private var coordinatesArray: [Double] = []
    private var mapTypeActions: [UIAction] = []
    private var placesActions: [UIAction] = []
    private let localizedMapTypes = [L10nMap.mapTypeHybrid,
                             L10nMap.mapTypeSatellite,
                             L10nMap.mapTypeMutedStandart,
                             L10nMap.mapTypeStandart]
    
    // MARK: - Public Properties
    var place = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        
        setupUI()
        
        coordinatesArray = retrieveCoordinates()
        if (coordinatesArray.isEmpty) {
            location.getCoordinates(address: place) { [weak self] latitude, longitude in
                self?.setLocation(latitude, longitude)
            }
        } else {
            setLocation(coordinatesArray.first ?? 0.0, coordinatesArray.last ?? 0.0)
        }
        
        popUpMapTypeMenu()
        popUpPlacesMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: safeAreaGhostView.frame.origin.y)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.5
        
        mapView.map.addSubview(blurView)
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(safeAreaGhostView)
        view.addSubview(mapView.map)
        
        safeAreaGhostView.translateMask()
        
        NSLayoutConstraint.activate([
            mapView.map.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.map.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.map.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            safeAreaGhostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaGhostView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            safeAreaGhostView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            safeAreaGhostView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func retrieveCoordinates() -> [Double] {
        let cleanedString = place.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
        
        let valueStrings = cleanedString.components(separatedBy: ";")
        
        var coordinates: [Double] = []
        
        for valueString in valueStrings {
            if let coordinate = Double(valueString) {
                coordinates.append(coordinate)
            }
        }
        return coordinates
    }
    
    private func setLocation(_ latitude: Double, _ longitude: Double) {
        location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 7500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.map.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = place
        mapView.map.addAnnotation(annotation)
        
        for city in cities {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
            annotation.title = city.explorerMode ? "\(city.latitude); \(city.longitude)" : city.name
            mapView.map.addAnnotation(annotation)
        }
    }
    
    private func popUpMapTypeMenu() {
        for (index, type) in MapType.allCases.enumerated() {
            let item = UIAction(title: localizedMapTypes[index]) { [weak self] _ in
                self?.mapView.map.mapType = type.mkMapType
            }
            mapTypeActions.append(item)
        }
        
        let menu = UIMenu(options: .displayInline, children: mapTypeActions.reversed())
        
        mapView.mapTypeButton.menu = menu
        mapView.mapTypeButton.showsMenuAsPrimaryAction = true
    }
    
    private func popUpPlacesMenu() {
        for city in cities {
            let item = UIAction(title: city.explorerMode ? "\(city.latitude); \(city.longitude)" : city.name) { [weak self] _ in
                self?.location = CLLocation(latitude: city.latitude, longitude: city.longitude)
                let regionRadius: CLLocationDistance = 7500
                if let coordinate = self?.location.coordinate {
                    let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                              latitudinalMeters: regionRadius,
                                                              longitudinalMeters: regionRadius)
                    self?.mapView.map.setRegion(coordinateRegion, animated: true)
                }
            }
            placesActions.append(item)
        }
        
        let menu = UIMenu(options: .displayInline, children: placesActions.reversed())
        
        mapView.placesButton.menu = menu
        mapView.placesButton.showsMenuAsPrimaryAction = true
    }
}

// MARK: - MapVC
private extension MapVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nMap.mapNavTitleText
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
    }
}
