//
//  SceneDelegate.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 30.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var main = MainVC()
    private var onboarding = OnboardingVC()
    private var isLight: Bool = true
    private var isDark: Bool = false
    private var isSystem: Bool = false
    
    private var n: Int = 0
    private var currentForecastTimer = Timer()

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navigationVC = UINavigationController()
        window?.rootViewController = navigationVC
        navigationVC.pushViewController(MainVC(), animated: false)
        window?.makeKeyAndVisible()
        
        // Appearance of the App
        setupAppearance()
        
        currentForecastTimer = Timer.scheduledTimer(withTimeInterval: 600.0, repeats: true) { _ in
            NotificationCenter.default.post(name: NotificationNames.updateLocation, object: nil, userInfo: nil)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        /*
         After user close the app, allowUpdateDBUsingWeatherKit will be true.
         And after next time user open SearchVC, the DB will update data
         */
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.allowUpdateDBUsingWeatherKit)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        onboarding.locationTimer.invalidate()
        currentForecastTimer.invalidate()
        currentForecastTimer.invalidate()
        
        /*
         After user close the app, allowUpdateDBUsingWeatherKit will be true.
         And after next time user open SearchVC, the DB will update data
         */
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.allowUpdateDBUsingWeatherKit)
    }
    
    private func setupAppearance() {
        let light = UserDefaults.standard.value(forKey: UserDefaultsKeys.lightKey) as? Bool
        let dark = UserDefaults.standard.value(forKey: UserDefaultsKeys.darkKey) as? Bool
        let system = UserDefaults.standard.value(forKey: UserDefaultsKeys.systemKey) as? Bool
        
        isLight = light ?? true
        isDark = dark ?? false
        isSystem = system ?? false
        
        NotificationCenter.default.addObserver(forName: NotificationNames.lightMode, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.isLight = true
            self.isDark = false
            self.isSystem = false
            UserDefaults.standard.set(self.isLight, forKey: UserDefaultsKeys.lightKey)
            UserDefaults.standard.set(self.isDark, forKey: UserDefaultsKeys.darkKey)
            UserDefaults.standard.set(self.isDark, forKey: UserDefaultsKeys.systemKey)
            
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(forName: NotificationNames.darkMode, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.isLight = false
            self.isDark = true
            self.isSystem = false
            UserDefaults.standard.set(self.isLight, forKey: UserDefaultsKeys.lightKey)
            UserDefaults.standard.set(self.isDark, forKey: UserDefaultsKeys.darkKey)
            UserDefaults.standard.set(self.isDark, forKey: UserDefaultsKeys.systemKey)
            
            self.window?.overrideUserInterfaceStyle = .dark
        }
        
        NotificationCenter.default.addObserver(forName: NotificationNames.systemMode, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.isLight = false
            self.isDark = false
            self.isSystem = true
            UserDefaults.standard.set(self.isLight, forKey: UserDefaultsKeys.lightKey)
            UserDefaults.standard.set(self.isDark, forKey: UserDefaultsKeys.darkKey)
            UserDefaults.standard.set(self.isSystem, forKey: UserDefaultsKeys.systemKey)
            
            self.window?.overrideUserInterfaceStyle = .unspecified
        }
        
        
        if isLight == true {
            window?.overrideUserInterfaceStyle = .light
        } else if isDark == true {
            window?.overrideUserInterfaceStyle = .dark
        } else if isSystem == true {
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }

}

