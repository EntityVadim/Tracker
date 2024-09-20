//
//  TrackerFilterViewController.swift
//  Tracker
//
//  Created by Вадим on 18.09.2024.
//

import UIKit

// MARK: - EnumTrackerFilterType

enum TrackerFilterType: String, CaseIterable {
    case all = "Все трекеры"
    case today = "Трекеры на сегодня"
    case completed = "Завершенные"
    case incomplete = "Не завершенные"
    
    func localizedString() -> String {
        switch self {
        case .all:
            return NSLocalizedString("filter_all_trackers", comment: "Все трекеры")
        case .today:
            return NSLocalizedString("filter_today_trackers", comment: "Трекеры на сегодня")
        case .completed:
            return NSLocalizedString("filter_completed_trackers", comment: "Завершенные")
        case .incomplete:
            return NSLocalizedString("filter_incomplete_trackers", comment: "Не завершенные")
        }
    }
}

// MARK: - TrackerFilterViewControllerDelegate

protocol TrackerFilterViewControllerDelegate: AnyObject {
    func filterTrackers(to categories: [TrackerCategory])
}

// MARK: - TrackerFilterViewController

final class TrackerFilterViewController: UIViewController {
    
    // MARK: - Identifier
    
    static let cellIdentifier = TrackerCategoryCell.identifier
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerFilterViewControllerDelegate?
    let dataManager = TrackerDataManager.shared
    var selectedFilter: Int?
    var filteredTrackers: [Tracker] = []
    var selectedDate = Date()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    // MARK: - Private Properties
    
    private var filterType: TrackerFilterType = .all
    private let calendar = Calendar.current
    private var dateLabel: UILabel?
    
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
    
    private func loadTrackers() {
        switch filterType {
        case .all:
            filteredTrackers = getAllTrackers(for: selectedDate)
        case .today:
            selectedDate = Date()
            filteredTrackers = getAllTrackers(for: selectedDate)
        case .completed:
            filteredTrackers = getCompletedTrackers(for: selectedDate)
        case .incomplete:
            filteredTrackers = getIncompleteTrackers(for: selectedDate)
        }
    }
    
    private func getAllTrackers(for date: Date) -> [Tracker] {
        var allTrackers: [Tracker] = []
        dataManager.loadCategories(for: date, dateFormatter: dateFormatter)
        for category in dataManager.categories {
            allTrackers.append(contentsOf: category.trackers)
        }
        return allTrackers.filter {
            dataManager.shouldDisplayTracker($0, forDate: date, dateFormatter: dateFormatter)
        }
    }
    
    private func getCompletedTrackers(for date: Date) -> [Tracker] {
        let allTrackers = getAllTrackers(for: date)
        return allTrackers.filter { tracker in
            return dataManager.completedTrackers.contains { $0.trackerId == tracker.id &&
                $0.date == dateFormatter.string(from: date) }
        }
    }
    
    private func getIncompleteTrackers(for date: Date) -> [Tracker] {
        let allTrackers = getAllTrackers(for: date)
        return allTrackers.filter { tracker in
            return !dataManager.completedTrackers.contains { $0.trackerId == tracker.id &&
                $0.date == dateFormatter.string(from: date) }
        }
    }
    
    // MARK: - Actions
    
    func switchFilter(to newFilter: TrackerFilterType) {
        filterType = newFilter
        let filteredCategories = dataManager.categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                switch filterType {
                case .all:
                    return true
                case .today:
                    let today = Calendar.current.isDateInToday(selectedDate)
                    return dataManager.shouldDisplayTracker(
                        tracker,
                        forDate: selectedDate,
                        dateFormatter: dateFormatter) && today
                case .completed:
                    return dataManager.completedTrackers.contains(where: { $0.trackerId == tracker.id })
                case .incomplete:
                    return !dataManager.completedTrackers.contains(where: { $0.trackerId == tracker.id })
                }
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(
                title: category.title,
                trackers: filteredTrackers)
        }
        delegate?.filterTrackers(to: filteredCategories)
    }
    
    func changeDate(to newDate: Date) {
        selectedDate = newDate
        dateLabel?.text = dateFormatter.string(from: newDate)
        loadTrackers()
    }
}
