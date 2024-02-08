//
//  ScheduleNotification_VC.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 12.06.23.
//

import UIKit
import SPIndicator
import UserNotifications

class ScheduleNotificationVC: UIViewController {
    
    // MARK: - Private Properties
    private let scheduleNotificationView = ScheduleNotificationView()
    
    // Model
    private let scheduleNotificationModel = ScheduleNotificationModel()
    
    // Converter
    private let timeConverter = TimeConverter()
    
    private var notificationHour: String = ""
    private var notificationMinute: String = ""
    private var amPM: String = ""
    
    private var currentNotificationTime: String = ""
    private var allowNotifications: Bool = false
    
    private var is24hFormat: Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
        view.backgroundColor = SettingsColors.backgroungWhite
        
        checkTimeFormat()
        setupUI()
        setupCurrentNotificationLabel()
        
        setDefaultSelection()
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewControllerToRightType1()
    }
    
    @objc private func didTapToggleButton() {
        allowNotifications = !allowNotifications
        UserDefaults.standard.set(allowNotifications, forKey: UserDefaultsKeys.allowNotifications)
        
        if !allowNotifications {
            cancelDailyNotification()
            UserDefaults.standard.set("", forKey: UserDefaultsKeys.currentNotificationTime)
            setupCurrentNotificationLabel()
        }
    }
    
    @objc private func didTapSetButton() {
        
        if notificationHour == "" {
            notificationHour = String(scheduleNotificationModel.current24HourIndex())
        }
        if notificationMinute == "" {
            if scheduleNotificationModel.currentMinuteIndex() < 10 {
                notificationMinute = String(repeating: "0", count: scheduleNotificationModel.currentMinuteIndex())
            } else {
                notificationMinute = String(scheduleNotificationModel.currentMinuteIndex())
            }
        }
        
        if allowNotifications {
            
            var timeString = ""
            let hour = Int(notificationHour)
            let minute = Int(notificationMinute)
            
            if is24hFormat {
                timeString = "\(notificationHour):\(notificationMinute)"
                createScheduleDailyNotification(hour, minute)
            } else {
                timeString = "\(notificationHour):\(notificationMinute) \(amPM)"
                createScheduleDailyNotification(hour, minute, amPM: amPM)
            }
            
            UserDefaults.standard.set("Current: \(timeString)", forKey: UserDefaultsKeys.currentNotificationTime)
            setupCurrentNotificationLabel()
            
            SPIndicator.present(title: "Notification is set to: \(timeString)", preset: .done, haptic: .success)
        } else {
            SPIndicator.present(title: "Turn on Notification", preset: .error, haptic: .error)
        }
    }
    
    // MARK: - Private Functions
    private func checkTimeFormat() {
        let timeFormatIsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.timeFormat) as? Bool
        is24hFormat = timeFormatIsDef ?? true
    }
    
    private func setupUI() {
        view.addSubview(scheduleNotificationView.mainView)
        
        NSLayoutConstraint.activate([
            scheduleNotificationView.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleNotificationView.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleNotificationView.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scheduleNotificationView.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scheduleNotificationView.toggleButton.addTarget(self, action: #selector(didTapToggleButton), for: .touchUpInside)
        scheduleNotificationView.setNotificationButton.addTarget(self, action: #selector(didTapSetButton), for: .touchUpInside)
        
        let allowNotificationsDef = UserDefaults.standard.value(forKey: UserDefaultsKeys.allowNotifications) as? Bool
        allowNotifications = allowNotificationsDef ?? false
        
        if allowNotifications {
            scheduleNotificationView.toggleButton.isOn = true
        }
        
        scheduleNotificationView.timePickerView.delegate = self
        scheduleNotificationView.timePickerView.dataSource = self
    }
    
    private func setupCurrentNotificationLabel() {
        let currentNotificationTimeDef = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentNotificationTime)
        currentNotificationTime = currentNotificationTimeDef ?? ""
        
        scheduleNotificationView.currentNotificationLabel.text = currentNotificationTime
    }
    
    private func createScheduleDailyNotification(_ hour: Int?, _ minute: Int?, amPM: String? = "") {
        let content = UNMutableNotificationContent()
        content.title = "Your weather for the day"
        content.body = "Today the average temperature is 26°C, rain is expected from 19:00"
        
        var hour24 = 0
        var minute60 = 0
        
        if is24hFormat {
            hour24 = Int(hour ?? 0)
            minute60 = Int(minute ?? 0)
        } else {
            let time24 = timeConverter.convertTo24HourFormat(time: "\(hour ?? 0):\(minute ?? 0) \(amPM ?? "")")
            let components = time24.components(separatedBy: ":")
            hour24 = Int(components[0]) ?? 0
            minute60 = Int(components[1]) ?? 0
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour24, minute: minute60, second: 0), repeats: true )
        
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled")
            }
        }
    }
    
    func cancelDailyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
    }
    
    // Call this method to set the default selection to the current time
    func setDefaultSelection() {
        let hour24Index = scheduleNotificationModel.current24HourIndex()
        let hour12Index = scheduleNotificationModel.current12HourIndex(is24hFormat)
        let minuteIndex = scheduleNotificationModel.currentMinuteIndex()
        let amPmIndex = scheduleNotificationModel.currentAmPmIndex()
        
        if is24hFormat {
            notificationHour = String(scheduleNotificationView.hours24[hour24Index])
            notificationMinute = String(format: "%02d", scheduleNotificationView.minutes[minuteIndex])
            scheduleNotificationView.timePickerView.selectRow(hour24Index, inComponent: 0, animated: false)
            scheduleNotificationView.timePickerView.selectRow(minuteIndex, inComponent: 1, animated: false)
        } else {
            scheduleNotificationView.timePickerView.selectRow(hour12Index, inComponent: 0, animated: false)
            scheduleNotificationView.timePickerView.selectRow(minuteIndex, inComponent: 1, animated: false)
            scheduleNotificationView.timePickerView.selectRow(amPmIndex, inComponent: 2, animated: false)
            notificationHour = String(scheduleNotificationView.hours12[hour12Index])
            notificationMinute = String(format: "%02d", scheduleNotificationView.minutes[minuteIndex])
            amPM = scheduleNotificationView.amPM[amPmIndex]
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ScheduleNotificationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if is24hFormat {
            return 2
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if is24hFormat {
            if component == 0 {
                return scheduleNotificationView.hours24.count
            } else {
                return scheduleNotificationView.minutes.count
            }
        } else {
            if component == 0 {
                return scheduleNotificationView.hours12.count
            } else if component == 1 {
                return scheduleNotificationView.minutes.count
            } else {
                return scheduleNotificationView.amPM.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CustomFonts.nunitoRegular, size: 22)
        
        if is24hFormat {
            if component == 0 {
                label.text = String(scheduleNotificationView.hours24[row])
            } else {
                label.text = String(format: "%02d", scheduleNotificationView.minutes[row])
            }
        } else {
            if component == 0 {
                label.text = String(scheduleNotificationView.hours12[row])
            } else if component == 1 {
                label.text = String(format: "%02d", scheduleNotificationView.minutes[row])
            } else {
                label.text = String(scheduleNotificationView.amPM[row])
            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if is24hFormat {
            if component == 0 {
                let selectedHour = String(scheduleNotificationView.hours24[row])
                notificationHour = selectedHour
            } else {
                let selectedMinute = String(format: "%02d", scheduleNotificationView.minutes[row])
                notificationMinute = selectedMinute
            }
        } else {
            if component == 0  {
                let selectedHour = String(scheduleNotificationView.hours12[row])
                notificationHour = selectedHour
            } else if component == 1 {
                let selectedMinute = String(format: "%02d", scheduleNotificationView.minutes[row])
                notificationMinute = selectedMinute
            } else {
                let selectedHalf = String(scheduleNotificationView.amPM[row])
                amPM = selectedHalf
            }
        }
    }
    
}

// MARK: - ScheduleNotificationVC
private extension ScheduleNotificationVC {
    func customNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationItem.title = L10nSettings.notificationButtonText
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
