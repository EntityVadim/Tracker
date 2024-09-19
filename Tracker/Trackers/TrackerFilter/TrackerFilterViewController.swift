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
    
    // MARK: - Public Properties
    
    var selectedFilter: Int?
    let filterOptions = [
        NSLocalizedString("filter_all_trackers", comment: "Все трекеры"),
        NSLocalizedString("filter_today_trackers", comment: "Трекеры на сегодня"),
        NSLocalizedString("filter_completed_trackers", comment: "Завершенные"),
        NSLocalizedString("filter_incomplete_trackers", comment: "Не завершенные")]
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .ypGrey
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
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
            
            tableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
