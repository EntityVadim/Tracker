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
            text: NSLocalizedString(
                "onboarding_text_first_page",
                comment: "Текст для первой страницы онбординга"),
            buttonTitle: NSLocalizedString(
                "onboarding_button_first_page",
                comment: "Текст кнопки для первой страницы онбординга"))
        let secondPage = OnboardingContentViewController(
            imageName: "OnboardingRed",
            text: NSLocalizedString(
                "onboarding_text_second_page",
                comment: "Текст для второй страницы онбординга"),
            buttonTitle: NSLocalizedString(
                "onboarding_button_second_page",
                comment: "Текст кнопки для второй страницы онбординга"))
        return [firstPage, secondPage]
    }()
    
    var currentIndex: Int {
        guard let currentViewController = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: currentViewController) ?? 0
    }
    
    // MARK: - Private Properties
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGrey
        pageControl.numberOfPages = 2
        pageControl.addTarget(
            self,
            action: #selector(pageControlValueChanged(_:)),
            for: .valueChanged)
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
        setupConstraints()
        
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let selectedIndex = sender.currentPage
        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ?
            .forward : .reverse
        setViewControllers(
            [pages[selectedIndex]],
            direction: direction,
            animated: true,
            completion: nil)
    }
}
