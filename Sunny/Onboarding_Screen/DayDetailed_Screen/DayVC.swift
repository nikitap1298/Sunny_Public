//
//  DayVC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 31.10.2022.
//

import UIKit
import DGCharts

enum GraphType {
    case temperature
    case precipitation
    case pressure
    case humidity
    case visibility
    case windSpeed
    case uvIndex
    case feelsLike
}

class DayVC: UIViewController, ChartViewDelegate {
    
    // MARK: - Private Properties
    private let dayConditionView = DayConditionView()
    private let popUpButtonView = PopUpButtonView()
    private let dayGraphView = DayGraphView()
    
    private let converter = Converter()
    private let timeConverter = TimeConverter()
    private var dayConditionModel = DayConditionModel()
    
    private var cellRange = 0...0
    
    private var buttonLabelText = ""
    private var buttonImage: UIImage?
    private var yAxis = [0.0]
    private var graphName = ""
    
    // MARK: - Public Properties
    var allWeatherModel = AllWeatherModels()
    var cellDate = ""
    var currentIndex = 0
    var timeZone = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingColors.backgroundBottom
        customNavigationBar()
        navigationItem.title = cellDate
        
        dayConditionModel.fillNameArray(data: allWeatherModel, currentIndex: currentIndex)
        dayConditionModel.fillImageArray(data: allWeatherModel, currentIndex: currentIndex)
        dayConditionModel.fillValueArray(data: allWeatherModel, currentIndex: currentIndex, timeZone: timeZone)
        
        cellData(currentIndex)
        setupDayGraphView()
        
        popUpMenu()
        
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    // MARK: - Private Functions
    private func setupDayGraphView() {
        view.addSubview(dayGraphView.lineChartView)
        view.addSubview(popUpButtonView.mainView)
        view.addSubview(dayConditionView.collectionView)
        
        NSLayoutConstraint.activate([
            dayConditionView.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dayConditionView.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            dayConditionView.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            dayConditionView.collectionView.bottomAnchor.constraint(equalTo: popUpButtonView.button.topAnchor, constant: -20),
            
            popUpButtonView.mainView.bottomAnchor.constraint(equalTo: dayGraphView.lineChartView.topAnchor, constant: -20),
            popUpButtonView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            popUpButtonView.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            popUpButtonView.mainView.heightAnchor.constraint(equalToConstant: 30),
            
            dayGraphView.lineChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            dayGraphView.lineChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dayGraphView.lineChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            dayGraphView.lineChartView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5)
        ])
        
        dayConditionView.collectionView.delegate = self
        dayConditionView.collectionView.dataSource = self
        
        graphType(.temperature)
    }
    
    private func setupDayGraph() {
        var entries = [ChartDataEntry]()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            if self.allWeatherModel.forecastStartHourly.count > 200 {
                
                for i in self.cellRange {
                    entries.append(ChartDataEntry(x: self.timeConverter.convertToSeconds(self.allWeatherModel.forecastStartHourly[i], self.timeZone),
                                                  y: self.yAxis[i]))
                }
                
            }
            
            let set1 = LineChartDataSet(entries: entries, label: self.graphName)
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
            
            self.dayGraphView.lineChartView.data = data
            self.dayGraphView.lineChartView.delegate = self
        }
    }
    
    private func popUpMenu() {
        let item0 = UIAction(title: GraphConditions.temperature, image: ConditionImages.thermometerHot) { [weak self] _ in
            self?.graphType(.temperature)
        }
        
        let item1 = UIAction(title: GraphConditions.precipitation, image: ConditionImages.umbrella) { [weak self] _ in
            self?.graphType(.precipitation)
        }
        
        let item2 = UIAction(title: GraphConditions.pressure, image: ConditionImages.pressure) { [weak self] _ in
            self?.graphType(.pressure)
        }
        
        let item3 = UIAction(title: GraphConditions.humidity, image: ConditionImages.humidity) { [weak self] _ in
            self?.graphType(.humidity)
        }
        
        let item4 = UIAction(title: GraphConditions.visibility, image: ConditionImages.visibility) { [weak self] _ in
            self?.graphType(.visibility)
        }
        
        let item5 = UIAction(title: GraphConditions.windSpeed, image: ConditionImages.wind) { [weak self] _ in
            self?.graphType(.windSpeed)
        }
        
        let item6 = UIAction(title: GraphConditions.uvIndex, image: ConditionImages.uvOrange) { [weak self] _ in
            self?.graphType(.uvIndex)
        }
        
        let item7 = UIAction(title: GraphConditions.feelsLike, image: ConditionImages.thermometerHot) { [weak self] _ in
            self?.graphType(.feelsLike)
        }
        
        let menu = UIMenu(options: .displayInline, children: [item7, item6, item5, item4, item3, item2, item1, item0])
        
        popUpButtonView.button.menu = menu
        popUpButtonView.button.showsMenuAsPrimaryAction = true
    }
    
    private func cellData(_ cellNumber: Int) {
        switch cellNumber {
        case 0:
            cellRange = 3...26
        case 1:
            cellRange = 27...50
        case 2:
            cellRange = 51...74
        case 3:
            cellRange = 75...98
        case 4:
            cellRange = 99...122
        case 5:
            cellRange = 123...146
        case 6:
            cellRange = 147...170
        case 7:
            cellRange = 171...194
        case 8:
            cellRange = 195...218
        case 9:
            cellRange = 219...242
        default:
            fatalError("Unexpected cellNumber: \(cellNumber)")
        }
    }
    
    private func graphType(_ graphType: GraphType) {
        switch graphType {
        case .temperature:
            buttonLabelText = GraphConditions.temperature
            buttonImage = ConditionImages.thermometerHot
            graphName = GraphConditions.temperature + GraphConditions.graphDescription
            yAxis = allWeatherModel.temperatureHourly
            dayGraphView.lineChartView.leftAxis.resetCustomAxisMin()
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterTemperature()
        case .precipitation:
            buttonLabelText = GraphConditions.precipitation
            buttonImage = ConditionImages.umbrella
            graphName = GraphConditions.precipitation + GraphConditions.graphDescription
            yAxis = allWeatherModel.precipitationAmountHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterPrecipitation()
        case .pressure:
            buttonLabelText = GraphConditions.pressure
            buttonImage = ConditionImages.pressure
            graphName = GraphConditions.pressure + GraphConditions.graphDescription
            yAxis = allWeatherModel.pressureHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterPressure()
        case .humidity:
            buttonLabelText = GraphConditions.humidity
            buttonImage = ConditionImages.humidity
            graphName = GraphConditions.humidity + GraphConditions.graphDescription
            yAxis = allWeatherModel.humidityHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterHumidity()
        case .visibility:
            buttonLabelText = GraphConditions.visibility
            buttonImage = ConditionImages.visibility
            graphName = GraphConditions.visibility + GraphConditions.graphDescription
            yAxis = allWeatherModel.visibilityHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterVisibility()
        case .windSpeed:
            buttonLabelText = GraphConditions.windSpeed
            buttonImage = ConditionImages.wind
            graphName = GraphConditions.windSpeed + GraphConditions.graphDescription
            yAxis = allWeatherModel.windSpeedHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterSpeed()
        case .uvIndex:
            buttonLabelText = GraphConditions.uvIndex
            buttonImage = ConditionImages.uvOrange
            graphName = GraphConditions.uvIndex + GraphConditions.graphDescription
            yAxis = allWeatherModel.uvIndexHourly.map { Double($0) }
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterUVIndex()
        case .feelsLike:
            buttonLabelText = GraphConditions.feelsLike
            buttonImage = ConditionImages.thermometerHot
            graphName = GraphConditions.feelsLike + GraphConditions.graphDescription
            yAxis = allWeatherModel.temperatureApparentHourly
            dayGraphView.lineChartView.leftAxis.valueFormatter = YAxisValueFormatterTemperature()
        }
        
        dayGraphView.lineChartView.leftAxis.resetCustomAxisMin()
        
        setupDayGraph()
        popUpButtonView.buttonLabel.text = buttonLabelText
        popUpButtonView.button.setImage(buttonImage, for: .normal)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DayVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayConditionModel.parameterValueArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dayConditionView.collectionView.dequeueReusableCell(withReuseIdentifier: ReusableConditionalSquareViewCell.reuseIdentifier, for: indexPath) as? ReusableConditionalSquareViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupParameterName(dayConditionModel.parameterNameArray[indexPath.row])
        cell.setupParameterImage(dayConditionModel.parameterImageArray[indexPath.row])
        cell.setupParameterValue(dayConditionModel.parameterValueArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tappedCell = collectionView.cellForItem(at: indexPath) as? ReusableConditionalSquareViewCell  {
            let viewController = ConditionDescriptionVC()
            viewController.allWeatherModel = allWeatherModel
            viewController.cellTitle = tappedCell.parameterNameLabel.text ?? "Title"
            viewController.cellValue = tappedCell.parameterValueLabel.text ?? "-"
            viewController.currentIndex = indexPath.row
            viewController.dayConditionModel = dayConditionModel
//            navigationController?.pushViewControllerFromRightType1(controller: viewController)
        }
    }
}

// MARK: - DayVC
private extension DayVC {
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
