//
//  AppDelegate.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let onboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
            if !onboardingCompleted {
                window = UIWindow(frame: UIScreen.main.bounds)
                let onboardingViewController = OnboardingViewController()
                window?.rootViewController = onboardingViewController
            } else {
                let rootViewController = MainTabBarController()
                window?.rootViewController = rootViewController
            }
            window?.makeKeyAndVisible()
            return true
        }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
