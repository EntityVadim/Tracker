//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Вадим on 08.08.2024.
//

import UIKit

// MARK: - TrackerCategory

final class TrackerCategoryViewController: UIViewController {
    
    // MARK: - Keys
    
    static let selectedCategory = "selectedCategory"
    
    // MARK: - Public Properties
    
    var categorySelectionHandler: ((TrackerCategory) -> Void)?
    
    var categories: [TrackerCategory] = [] {
        didSet {
            if let selectedCategory {
                saveCategories(selectedCategory.title)
            }
        }
    }
    
    var selectedCategory: TrackerCategory? {
        didSet {
            saveSelectedCategory()
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Error"))
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedString = NSAttributedString(
            string: "Привычки и события можно\n объединить по смыслу",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .paragraphStyle: paragraphStyle]
        )
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(
            self,
            action: #selector(addCategoryButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.ypGrey
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        loadCategories()
        loadSelectedCategory()
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.identifier)
        updateUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel, errorImageView, placeholderLabel, addCategoryButton, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20)
        ])
    }
    
    // MARK: - Private Methods
    
    private func saveCategories(_ categoryName: String) {
        trackerCategoryStore.addCategory(title: categoryName, trackers: [])
    }
    
    private func updateUI() {
        if categories.isEmpty {
            errorImageView.isHidden = false
            placeholderLabel.isHidden = false
            tableView.isHidden = true
        } else {
            errorImageView.isHidden = true
            placeholderLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func loadCategories() {
        do {
            categories = try trackerCategoryStore.getCategory()
        } catch {
            print("Сохранение не удалось: \(error)")
        }
        updateUI()
    }
    
    private func saveSelectedCategory() {
        UserDefaults.standard.set(
            selectedCategory?.title,
            forKey: TrackerCategoryViewController.selectedCategory)
    }
    
    private func loadSelectedCategory() {
        guard let title = UserDefaults.standard.string(
            forKey: TrackerCategoryViewController.selectedCategory
        ) else {
            return
        }
        selectedCategory = TrackerCategory(title: title, trackers: [])
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        guard let selectedCategory = selectedCategory else {
            let newCategoryVC = TrackerNewCategoryViewController()
            newCategoryVC.onCategorySave = { [weak self] categoryName in
                self?.trackerCategoryStore.addCategory(title: categoryName.title, trackers: [])
                self?.categories.append(categoryName)
                self?.selectedCategory = categoryName
                self?.tableView.reloadData()
            }
            present(newCategoryVC, animated: true, completion: nil)
            return
        }
        categorySelectionHandler?(selectedCategory)
        dismiss(animated: true, completion: nil)
        updateUI()
    }
}
