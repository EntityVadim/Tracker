//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

// MARK: - MainTabBar

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        let trackersViewController = UINavigationController(rootViewController: TrackerViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "tab_title_trackers",
                comment: "Название вкладки для трекеров"),
            image: UIImage(named: "Trackers"),
            selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "tab_title_statistics",
                comment: "Название вкладки для статистики"),
            image: UIImage(named: "Statistics"),
            selectedImage: nil)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupAppearance() {
        let activeTabColor: UIColor = .ypBlue
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        tabBar.tintColor = activeTabColor
        tabBar.barTintColor = isDarkMode ? .ypWhite : .ypBlack
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topBorder.backgroundColor = .ypBackgroundDay
        tabBar.addSubview(topBorder)
    }
}
