//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Вадим on 08.08.2024.
//

import UIKit

// MARK: - TrackerCategory

final class TrackerCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var categorySelectionHandler: ((String) -> Void)?
    
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
    
    private var categories: [String] = [] {
        didSet { saveCategories() }
    }
    
    private var selectedCategory: String? {
        didSet {
            saveSelectedCategory()
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        loadCategories()
        loadSelectedCategory()
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: "CustomCategoryCell")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel,
         addCategoryButton,
         tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20)
        ])
    }
    
    // MARK: - UserDefaults Methods
    
    private func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }
    
    private func loadCategories() {
        categories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
    }
    
    private func saveSelectedCategory() {
        UserDefaults.standard.set(selectedCategory, forKey: "selectedCategory")
    }
    
    private func loadSelectedCategory() {
        selectedCategory = UserDefaults.standard.string(forKey: "selectedCategory")
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        guard let selectedCategory = selectedCategory else {
            let newCategoryVC = TrackerNewCategoryViewController()
            newCategoryVC.onCategorySave = { [weak self] categoryName in
                self?.categories.append(categoryName)
                self?.selectedCategory = categoryName
                self?.tableView.reloadData()
            }
            present(newCategoryVC, animated: true, completion: nil)
            return
        }
        categorySelectionHandler?(selectedCategory)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return categories.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomCategoryCell",
                for: indexPath) as? TrackerCategoryCell else {
                return UITableViewCell()
            }
            let category = categories[indexPath.row]
            let isSelected = category == selectedCategory
            cell.configure(with: category, isSelected: isSelected)
            cell.contentView.backgroundColor = .ypLightGray
            return cell
        }
}

// MARK: - UITableViewDelegate

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            if indexPath.row == 0 && categories.count == 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner]
            } else if indexPath.row == categories.count - 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
            } else {
                cell.contentView.layer.cornerRadius = 0
            }
            cell.contentView.layer.masksToBounds = true
        }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let category = categories[indexPath.row]
        if category == selectedCategory {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
        tableView.reloadData()
    }
}
