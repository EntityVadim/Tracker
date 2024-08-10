//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    private func setupViewControllers() {
        let trackersViewController = UINavigationController(rootViewController: TrackerViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistics"),
            selectedImage: nil)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        tabBar.tintColor = isDarkMode ? .ypWhite : .ypBlack
        tabBar.barTintColor = isDarkMode ? .ypBlack : .ypBlack
    }
}
