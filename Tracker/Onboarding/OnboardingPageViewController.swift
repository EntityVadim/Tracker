//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Вадим on 03.09.2024.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    static let onboardingCompletedKey = "isOnboardingCompleted"
    
    // MARK: - Private Properties
    
    let pages: [UIViewController] = {
        let firstPage = OnboardingContentViewController(
            imageName: "OnboardingBlue",
            text: "Отслеживайте только\n то, что хотите",
            buttonTitle: "Вот это технологии!")
        let secondPage = OnboardingContentViewController(
            imageName: "OnboardingRed",
            text: "Даже если это\n не литры воды и йога",
            buttonTitle: "Вот это технологии!")
        return [firstPage, secondPage]
    }()
    
    var currentIndex: Int {
        guard let currentViewController = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: currentViewController) ?? 0
    }
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = 2
        return pageControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updatePageControl() {
        pageControl.currentPage = currentIndex
    }
}

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
