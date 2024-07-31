//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

//final class TrackersViewController: UIViewController {
//
//    // MARK: - Private Properties
//
//    private lazy var addButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "Plus"), for: .normal)
//        button.addTarget(
//            self,
//            action: #selector(addTracker),
//            for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(
//            self,
//            action: #selector(datePickerValueChanged(_:)),
//            for: .valueChanged)
//        datePicker.isHidden = true
//        return datePicker
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Трекеры"
//        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
//        return label
//    }()
//
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Поиск"
//        return searchBar
//    }()
//
//    private let errorImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "Error"))
//        return imageView
//    }()
//
//    private let trackingLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Что будем отслеживать?"
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textAlignment = .center
//        return label
//    }()
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//    }
//
//    // MARK: - Private Methods
//
//    private func setupUI() {
//        [addButton,
//         datePicker,
//         titleLabel,
//         searchBar,
//         errorImageView,
//         trackingLabel].forEach { [weak self] view in
//            guard let self = self else { return }
//            self.view.addSubview(view)
//            view.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        NSLayoutConstraint.activate([
//            addButton.widthAnchor.constraint(equalToConstant: 42),
//            addButton.heightAnchor.constraint(equalToConstant: 42),
//            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
//            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
//
//            datePicker.widthAnchor.constraint(equalToConstant: 77),
//            datePicker.heightAnchor.constraint(equalToConstant: 34),
//            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
//            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//
//            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//
//            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            searchBar.heightAnchor.constraint(equalToConstant: 36),
//
//            errorImageView.widthAnchor.constraint(equalToConstant: 80),
//            errorImageView.heightAnchor.constraint(equalToConstant: 80),
//            errorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
//            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            trackingLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
//            trackingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            trackingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            trackingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            trackingLabel.heightAnchor.constraint(equalToConstant: 18)
//        ])
//    }
//
//    // MARK: - Actions
//
//    @objc private func addTracker() {
//        print("Добавить трекер")
//    }
//
//    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yy"
//        let dateString = dateFormatter.string(from: sender.date)
//        print("Дата изменена на \(dateString)")
//    }
//}


final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker))
        return button
    }()
    
    private lazy var datePicker: UIBarButtonItem = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItems = [addButton]
        navigationItem.rightBarButtonItems = [datePicker]
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        titleView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        navigationItem.titleView = titleView
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
    }
    
    private func setupUI() {
        [errorImageView,
         trackingLabel].forEach { [weak self] view in
            guard let self else { return }
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackingLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackingLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        print("Добавить трекер")
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: sender.date)
        print("Дата изменена на \(dateString)")
    }
}
