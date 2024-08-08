//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Вадим on 08.08.2024.
//

import UIKit

final class TrackerCategoryViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(
            self,
            action: #selector(addCategoryButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private var categories: [String] = [] {
        didSet {
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .ypWhite
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel,
         addCategoryButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = TrackerNewCategoryViewController()
        newCategoryVC.onCategorySave = { [weak self] categoryName in
            self?.categories.append(categoryName)
        }
        present(newCategoryVC, animated: true, completion: nil)
    }
}
