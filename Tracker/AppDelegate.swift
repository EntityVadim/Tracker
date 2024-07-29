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
            window = UIWindow(frame: UIScreen.main.bounds)
            let launchViewController = LaunchScreenViewController()
            window?.rootViewController = launchViewController
            window?.makeKeyAndVisible()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let rootViewController = ViewController()
                self.window?.rootViewController = rootViewController
            }
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
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        }
}
