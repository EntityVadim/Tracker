//
//  TrackerScheduleViewController.swift
//  Tracker
//
//  Created by Вадим on 08.08.2024.
//

import UIKit

// MARK: - Enum

enum WeekDay: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    func localizedString() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("week_day_monday", comment: "Понедельник")
        case .tuesday:
            return NSLocalizedString("week_day_tuesday", comment: "Вторник")
        case .wednesday:
            return NSLocalizedString("week_day_wednesday", comment: "Среда")
        case .thursday:
            return NSLocalizedString("week_day_thursday", comment: "Четверг")
        case .friday:
            return NSLocalizedString("week_day_friday", comment: "Пятница")
        case .saturday:
            return NSLocalizedString("week_day_saturday", comment: "Суббота")
        case .sunday:
            return NSLocalizedString("week_day_sunday", comment: "Воскресенье")
        }
    }
}

// MARK: - TrackerSchedule

final class TrackerScheduleViewController: UIViewController {
    
    // MARK: - Identifier
    
    static let cellIdentifier = "TrackerScheduleCell"
    
    // MARK: - Public Properties
    
    var selectedDays: [WeekDay] = []
    var daySelectionHandler: (([WeekDay]) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .ypGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: TrackerScheduleViewController.cellIdentifier)
        return tableView
    }()
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "title_label_text_schedule",
            comment: "Заголовок для расписания")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString(
            "save_button_title",
            comment: "Кнопка для сохранения расписания"), for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel, tableView, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        daySelectionHandler?(selectedDays)
        dismiss(animated: true, completion: nil)
    }
}
