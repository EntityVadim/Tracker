//
//  Extension OnboardingPage.swift
//  Tracker
//
//  Created by Вадим on 04.09.2024.
//

import UIKit

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            let index = currentIndex
            return index == 0 ? nil : pages[index - 1]
        }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let index = currentIndex
            return index == pages.count - 1 ? nil : pages[index + 1]
        }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            updatePageControl()
        }
    }
}
