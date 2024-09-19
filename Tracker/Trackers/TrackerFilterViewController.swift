//
//  TrackerFilterViewController.swift
//  Tracker
//
//  Created by Вадим on 18.09.2024.
//

import UIKit

// MARK: - TrackerFilterViewController

final class TrackerFilterViewController: UIViewController {
    
    // MARK: - Identifier
    
    static let cellIdentifier = TrackerCategoryCell.identifier
    
    // MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .ypGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypWhite
        tableView.register(
            TrackerCategoryCell.self,
            forCellReuseIdentifier: TrackerFilterViewController.cellIdentifier)
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "title_label_text_filters",
            comment: "Заголовок для фильтров")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // MARK: - Properties
    
    private let filterOptions = [
        NSLocalizedString("filter_all_trackers", comment: "Все трекеры"),
        NSLocalizedString("filter_today_trackers", comment: "Трекеры на сегодня"),
        NSLocalizedString("filter_completed_trackers", comment: "Завершенные"),
        NSLocalizedString("filter_incomplete_trackers", comment: "Не завершенные")
    ]
    
    private var selectedFilter: Int? // Tracks the selected filter
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableViewDataSource

extension TrackerFilterViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return filterOptions.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFilterViewController.cellIdentifier,
                for: indexPath) as! TrackerCategoryCell
            let option = filterOptions[indexPath.row]
            let isSelected = indexPath.row == selectedFilter
            cell.configure(with: option, isSelected: isSelected)
            return cell
        }
}

// MARK: - UITableViewDelegate

extension TrackerFilterViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            selectedFilter = indexPath.row
            tableView.reloadData()
    }
}
