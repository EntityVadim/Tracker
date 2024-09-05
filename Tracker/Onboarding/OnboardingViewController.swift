//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

// MARK: - OnboardingContent

final class OnboardingContentViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let imageView: UIImageView
    private let textLabel: UILabel
    private let actionButton: UIButton
    
    // MARK: - Initialization
    
    init(imageName: String, text: String, buttonTitle: String) {
        self.imageView = UIImageView(image: UIImage(named: imageName))
        self.textLabel = UILabel()
        self.actionButton = UIButton()
        super.init(nibName: nil, bundle: nil)
        self.textLabel.text = text
        self.textLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        self.textLabel.textAlignment = .center
        self.textLabel.numberOfLines = 0
        self.actionButton.setTitle(buttonTitle, for: .normal)
        self.actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.actionButton.backgroundColor = .black
        self.actionButton.setTitleColor(.white, for: .normal)
        self.actionButton.layer.cornerRadius = 16
        self.actionButton.layer.masksToBounds = true
        self.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        [imageView, textLabel, actionButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -160),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapActionButton() {
        if let parentPageViewController = parent as? OnboardingPageViewController {
            if parentPageViewController.currentIndex == parentPageViewController.pages.count - 2 {
                UserDefaults.standard.set(true, forKey: OnboardingPageViewController.onboardingCompletedKey)
                let mainTabBarController = MainTabBarController()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = mainTabBarController
                    UIView.transition(
                        with: window,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: nil,
                        completion: nil)
                }
            } else {
                parentPageViewController.setViewControllers(
                    [parentPageViewController.pages[parentPageViewController.currentIndex + 1]],
                    direction: .forward,
                    animated: true,
                    completion: nil)
            }
        }
    }
}
