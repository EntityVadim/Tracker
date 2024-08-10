//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var dataManager = TrackerDataManager()
    private var selectedDate: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker))
        button.tintColor = .black
        return button
    }()
    
    private lazy var datePicker: UIBarButtonItem = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged)
        return UIBarButtonItem(customView: datePicker)
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Error"))
        return imageView
    }()
    
    private let trackingLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        setupConstraints()
        updateTrackersView()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItems = [addButton]
        navigationItem.rightBarButtonItems = [datePicker]
    }
    
    private func setupConstraints() {
        [titleLabel,
         searchBar,
         errorImageView,
         trackingLabel,
         collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDarkMode ? .ypBlack : .ypWhite
        titleLabel.textColor = isDarkMode ? .ypWhite : .ypBlack
        trackingLabel.textColor = isDarkMode ? .ypWhite : .ypBlack
        searchBar.barTintColor = isDarkMode ? .ypBlack : .ypWhite
        addButton.tintColor = isDarkMode ? .ypWhite : .ypBlack
    }
    
    private func updateTrackersView() {
        let trackers = dataManager.categories.flatMap { $0.trackers }
        let hasTrackers = !trackers.isEmpty
        errorImageView.isHidden = hasTrackers
        trackingLabel.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
        collectionView.reloadData()
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
    }
}

// MARK: - TrackerTypeSelectionDelegate

extension TrackerViewController: TrackerTypeSelectionDelegate, TrackerCreationDelegate {
    func didCreateTracker(
        _ tracker: Tracker,
        inCategory category: String
    ) {
        dataManager.addNewTracker(to: category, tracker: tracker)
        updateTrackersView()
    }
    
    func didSelectTrackerType(_ type: TrackerType) {
        dismiss(animated: true) {
            let createTrackerVC = TrackerCreationViewController()
            createTrackerVC.trackerType = type
            createTrackerVC.delegate = self
            self.present(createTrackerVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension TrackerViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionCount = dataManager.categories.count
        return sectionCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            let itemCount = dataManager.categories[section].trackers.count
            return itemCount
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TrackerCell",
                for: indexPath) as? TrackerCell else {
                return UICollectionViewCell()
            }
            let category = dataManager.categories[indexPath.section]
            let tracker = category.trackers[indexPath.item]
            let completedTrackers = dataManager.completedTrackers.filter { $0.trackerId == tracker.id }
            cell.configure(with: tracker, completedTrackers: completedTrackers, dataManager: dataManager)
            cell.delegate = self
            return cell
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "TrackerSectionHeader",
                    for: indexPath
                ) as? TrackerSectionHeader else {
                    return UICollectionReusableView()
                }
                let category = dataManager.categories[indexPath.section]
                headerView.titleLabel.text = category.title
                return headerView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}

// MARK: - TrackerCellDelegate

extension TrackerViewController: TrackerCellDelegate {
    func trackerCellDidToggleCompletion(
        _ cell: TrackerCell,
        for tracker: Tracker
    ) {
        updateTrackersView()
    }
}
