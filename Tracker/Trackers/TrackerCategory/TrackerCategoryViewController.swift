//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Вадим on 08.08.2024.
//

import UIKit

// MARK: - TrackerCategoryViewController

final class TrackerCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let viewModel = TrackerCategoryViewModel()
    var categorySelectionHandler: ((TrackerCategory) -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "title_label_text",
            comment: "Заголовок для выбора категории")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Error"))
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedString = NSAttributedString(
            string: NSLocalizedString(
                "placeholder_text",
                comment: "Текст плейсхолдера для категории"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString(
            "add_category_button_title",
            comment: "Текст кнопки добавления категории"), for: .normal)
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
        tableView.backgroundColor = .ypWhite
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.identifier)
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
        setupConstraints()
        bindViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        [titleLabel, errorImageView, placeholderLabel, addCategoryButton, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
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
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.updateUI()
        }
        viewModel.saveCategory = { [weak self] in
            self?.tableView.reloadData()
        }
        updateUI()
    }
    
    private func updateUI() {
        if viewModel.categories.isEmpty {
            errorImageView.isHidden = false
            placeholderLabel.isHidden = false
            tableView.isHidden = true
        } else {
            errorImageView.isHidden = true
            placeholderLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        if let selectedCategory = viewModel.selectedCategory {
            categorySelectionHandler?(selectedCategory)
            dismiss(animated: true, completion: nil)
        } else {
            let newCategoryVC = TrackerNewCategoryViewController()
            newCategoryVC.onCategorySave = { [weak self] categoryName in
                self?.viewModel.addCategory(with: categoryName.title)
            }
            present(newCategoryVC, animated: true, completion: nil)
        }
    }
}
