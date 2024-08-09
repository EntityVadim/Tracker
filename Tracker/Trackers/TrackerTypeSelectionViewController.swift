//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Вадим on 07.08.2024.
//

import UIKit

// MARK: - Protocol

protocol TrackerTypeSelectionDelegate: AnyObject {
    func didSelectTrackerType(_ type: TrackerType)
}

// MARK: - Enums

enum TrackerType {
    case habit
    case irregularEvent
}

// MARK: - TrackerTypeSelection

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerTypeSelectionDelegate?
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(
            self,
            action: #selector(habitButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(
            self,
            action: #selector(irregularEventButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        [titleLabel,
         habitButton,
         irregularEventButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            irregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDarkMode ? .ypBlack : .ypWhite
        titleLabel.textColor = isDarkMode ? .ypWhite : .ypBlack
        habitButton.backgroundColor = isDarkMode ? .ypWhite : .ypBlack
        habitButton.setTitleColor(isDarkMode ? .ypBlack : .ypWhite, for: .normal)
        irregularEventButton.backgroundColor = isDarkMode ? .ypWhite : .ypBlack
        irregularEventButton.setTitleColor(isDarkMode ? .ypBlack : .ypWhite, for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func showCreateTrackerScreen(with type: TrackerType) {
        let createTrackerVC = TrackerCreationViewController()
        createTrackerVC.trackerType = type
        createTrackerVC.modalPresentationStyle = .fullScreen
        present(createTrackerVC, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func habitButtonTapped() {
        delegate?.didSelectTrackerType(.habit)
        showCreateTrackerScreen(with: .habit)
    }
    
    @objc private func irregularEventButtonTapped() {
        delegate?.didSelectTrackerType(.irregularEvent)
        showCreateTrackerScreen(with: .irregularEvent)
    }
}
