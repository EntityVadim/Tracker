//  TrackersViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
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
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
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
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = isDarkMode ? .black : .white
        titleLabel.textColor = isDarkMode ? .white : .black
        trackingLabel.textColor = isDarkMode ? .white : .black
        searchBar.barTintColor = isDarkMode ? .black : .white
        addButton.tintColor = isDarkMode ? .white : .black
    }
    
    private func markTrackerAsCompleted(trackerId: UUID, date: String) {
        let record = TrackerRecord(trackerId: trackerId, date: date)
        completedTrackers.append(record)
        print("Трекер отмечен как выполненный на дату \(date)")
    }
    
    private func unmarkTrackerAsCompleted(trackerId: UUID, date: String) {
        completedTrackers.removeAll { $0.trackerId == trackerId && $0.date == date }
        print("Трекер отмечен как невыполненный на дату \(date)")
    }
    
    private func addNewTracker(to categoryTitle: String, tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            var updatedCategory = categories[index]
            updatedCategory.trackers.append(tracker)
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
        print("Всего категорий: \(categories.count)")
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        let newTracker = Tracker(
            id: UUID(),
            name: "New Tracker",
            color: UIColor(red: 47/255, green: 208/255, blue: 88/255, alpha: 1),
            emoji: "⭐️",
            schedule: ["Monday"]
        )
        let categoryTitle = "Existing Category"
        if !categories.contains(where: { $0.title == categoryTitle }) {
            print("Категория \(categoryTitle) не существует. Создаем новую категорию.")
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
            categories.append(newCategory)
        }
        addNewTracker(to: categoryTitle, tracker: newTracker)
        print("Трекер добавлен в категорию \(categoryTitle)")
        for category in categories {
            print("Категория: \(category.title), количество трекеров: \(category.trackers.count)")
        }
        print("Перезагрузка данных коллекции")
        collectionView.reloadData()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: sender.date)
        print("Дата изменена на \(dateString)")
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let trackers = categories.flatMap { $0.trackers }
        if trackers.isEmpty {
            errorImageView.isHidden = false
            trackingLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            errorImageView.isHidden = true
            trackingLabel.isHidden = true
            collectionView.isHidden = false
        }
        print("Количество трекеров: \(trackers.count)")
        return trackers.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let trackers = categories.flatMap { $0.trackers }
        let tracker = trackers[indexPath.item]
        cell.configure(with: tracker, completedTrackers: completedTrackers)
        cell.delegate = self
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 20, height: 100)
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func trackerCellDidToggleCompletion(_ cell: TrackerCell, for tracker: Tracker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: UIDatePicker().date)
        if cell.isCompletedForToday() {
            unmarkTrackerAsCompleted(trackerId: tracker.id, date: dateString)
        } else {
            markTrackerAsCompleted(trackerId: tracker.id, date: dateString)
        }
        collectionView.reloadData()
    }
}
