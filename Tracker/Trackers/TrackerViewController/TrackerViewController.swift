//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

// MARK: - Tracker

final class TrackerViewController: UIViewController, TrackerFilterViewControllerDelegate {
    
    // MARK: - Public Properties
    
    var trackerFilterViewController = TrackerFilterViewController()
    var selectedDate: Date = Date()
    let dataManager = TrackerDataManager.shared
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    // MARK: - Private Properties
    
    private(set) var visibleCategories: [TrackerCategory] = []
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker))
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var datePicker: UIBarButtonItem = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged)
        return UIBarButtonItem(customView: datePicker)
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "tracker_title",
            comment: "Заголовок экрана трекеров")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString(
            "search_placeholder",
            comment: "Подсказка для поиска трекеров")
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Error"))
        return imageView
    }()
    
    private lazy var trackingLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "error_tracking",
            comment: "Текст-заполнитель, если нет трекеров для отслеживания")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorFilterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ErrorFillter"))
        return imageView
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "filter_no_results",
            comment: "Сообщение о том, что ничего не найдено")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TrackerSectionHeader")
        return collectionView
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString(
            "filters_button_title",
            comment: "Кнопка фильтров"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapFiltersButton),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
        setupNavigationBar()
        updateTrackersView()
        visibleCategories = dataManager.categories
        searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomInset = filtersButton.frame.height + 32
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    // MARK: - Public Methods
    
    func updateTrackersView() {
        dataManager.loadCategories(for: selectedDate, dateFormatter: dateFormatter)
        let trackers = dataManager.categories.flatMap { $0.trackers }
        _ = trackers.filter {
            dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
        }
        if let searchText = searchBar.text, !searchText.isEmpty {
            visibleCategories = filterTrackersSearchBar(by: searchText, from: dataManager.categories)
        } else {
            visibleCategories = dataManager.categories
        }
        let hasTrackers = !visibleCategories.flatMap { $0.trackers }.isEmpty
        filtersButton.isHidden = !hasTrackers
        errorImageView.isHidden = hasTrackers
        trackingLabel.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
        collectionView.reloadData()
    }
    
    func filterTrackersSearchBar(by searchText: String, from categories: [TrackerCategory]) -> [TrackerCategory] {
        return categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.name.lowercased().contains(searchText.lowercased())
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
    }
    
    func filterTrackers(to categories: [TrackerCategory]) {
        visibleCategories = categories
        collectionView.reloadData()
    }
    
    func presentEditTrackerViewController(for tracker: Tracker) {
        let editTrackerVC = TrackerCreationViewController()
        editTrackerVC.trackerToEdit = tracker
        editTrackerVC.delegate = self
        present(editTrackerVC, animated: true, completion: nil)
    }
    
    func handleDeleteTracker(_ tracker: Tracker) {
        let alertController = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить трекер?",
            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ) { _ in
            let currentDate = self.selectedDate
            let dateFormatter = self.dateFormatter
            self.dataManager.deleteTracker(withId: tracker.id, for: currentDate, dateFormatter: dateFormatter)
            self.updateTrackersView()
        }
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel,
            handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        [titleLabel, searchBar, errorImageView, trackingLabel,
         errorFilterImageView, filterLabel, collectionView, filtersButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackingLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackingLabel.heightAnchor.constraint(equalToConstant: 18),
            
            errorFilterImageView.widthAnchor.constraint(equalToConstant: 80),
            errorFilterImageView.heightAnchor.constraint(equalToConstant: 80),
            errorFilterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            errorFilterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterLabel.topAnchor.constraint(equalTo: errorFilterImageView.bottomAnchor, constant: 8),
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterLabel.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: filtersButton.topAnchor, constant: -16),
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItems = [addButton]
        navigationItem.rightBarButtonItems = [datePicker]
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        trackerTypeSelectionVC.delegate = self
        present(trackerTypeSelectionVC, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateTrackersView()
        trackerFilterViewController.delegate = self
        trackerFilterViewController.changeDate(to: sender.date)
    }
    
    @objc private func didTapFiltersButton() {
        let filterViewController = TrackerFilterViewController()
        filterViewController.modalPresentationStyle = .formSheet
        filterViewController.delegate = self
        present(filterViewController, animated: true, completion: nil)
    }
}
