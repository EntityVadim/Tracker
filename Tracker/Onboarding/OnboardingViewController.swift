//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

// MARK: - OnboardingViewController

final class OnboardingViewController: UIViewController {
    
    // MARK: - Keys
    
    static let onboardingCompletedKey = "isOnboardingCompleted"
    
    // MARK: - Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        return makeLabel(withText: "Отслеживайте только то, что хотите")
    }()
    
    private lazy var secondLabel: UILabel = {
        return makeLabel(withText: "Даже если это не литры воды и йога")
    }()
    
    private lazy var firstActionButton: UIButton = {
        return makeActionButton(withTitle: "Вот это технологии!")
    }()
    
    private lazy var secondActionButton: UIButton = {
        return makeActionButton(withTitle: "Вот это технологии!")
    }()
    
    private lazy var firstScreenView: UIImageView = {
        return makeImageView(withImageNamed: "OnboardingBlue")
    }()
    
    private lazy var secondScreenView: UIImageView = {
        return makeImageView(withImageNamed: "OnboardingRed")
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.height)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 2, height: scrollView.frame.height)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [firstScreenView,
         secondScreenView,
         firstLabel,
         secondLabel,
         firstActionButton,
         secondActionButton].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            firstScreenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstScreenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            firstScreenView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            secondScreenView.leadingAnchor.constraint(equalTo: firstScreenView.trailingAnchor),
            secondScreenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            secondScreenView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            firstLabel.leadingAnchor.constraint(equalTo: firstScreenView.leadingAnchor, constant: 16),
            firstLabel.trailingAnchor.constraint(equalTo: firstScreenView.trailingAnchor, constant: -16),
            firstLabel.bottomAnchor.constraint(equalTo: firstActionButton.topAnchor, constant: -160),
            
            secondLabel.leadingAnchor.constraint(equalTo: secondScreenView.leadingAnchor, constant: 16),
            secondLabel.trailingAnchor.constraint(equalTo: secondScreenView.trailingAnchor, constant: -16),
            secondLabel.bottomAnchor.constraint(equalTo: secondActionButton.topAnchor, constant: -160),
            
            firstActionButton.leadingAnchor.constraint(equalTo: firstScreenView.leadingAnchor, constant: 20),
            firstActionButton.trailingAnchor.constraint(equalTo: firstScreenView.trailingAnchor, constant: -20),
            firstActionButton.bottomAnchor.constraint(equalTo: firstScreenView.bottomAnchor, constant: -84),
            firstActionButton.heightAnchor.constraint(equalToConstant: 60),
            
            secondActionButton.leadingAnchor.constraint(equalTo: secondScreenView.leadingAnchor, constant: 20),
            secondActionButton.trailingAnchor.constraint(equalTo: secondScreenView.trailingAnchor, constant: -20),
            secondActionButton.bottomAnchor.constraint(equalTo: secondScreenView.bottomAnchor, constant: -84),
            secondActionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    private func makeActionButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }
    
    private func makeImageView(withImageNamed name: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: name))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    @objc private func didTapActionButton() {
        UserDefaults.standard.set(true, forKey: OnboardingViewController.onboardingCompletedKey)
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
    }
}
