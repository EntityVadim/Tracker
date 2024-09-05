//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Вадим on 03.09.2024.
//

import UIKit

// MARK: - OnboardingPage

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Identifier
    
    static let onboardingCompletedKey = "isOnboardingCompleted"
    
    // MARK: - Public Properties
    
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
    
    // MARK: - Private Properties
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGrey
        pageControl.numberOfPages = 2
        return pageControl
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupUI()
        
        if let firstPage = pages.first {
            setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
    
    // MARK: - Public Methods
    
    func updatePageControl() {
        pageControl.currentPage = currentIndex
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let selectedIndex = sender.currentPage
        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse
        setViewControllers([pages[selectedIndex]], direction: direction, animated: true, completion: nil)
    }
}
