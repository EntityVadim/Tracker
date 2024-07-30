//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Plus"), for: .normal)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let dateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 4
        return view
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
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupDateLabel() {
        dateContainer.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    private func setupUI() {
        [addButton,
         dateContainer,
         titleLabel,
         searchBar,
         errorImageView,
         trackingLabel].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        setupDateLabel()
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            
            dateContainer.widthAnchor.constraint(equalToConstant: 77),
            dateContainer.heightAnchor.constraint(equalToConstant: 34),
            dateContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            dateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.widthAnchor.constraint(equalToConstant: 66),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -5),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
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
            trackingLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        // Действие для добавления трекера
    }
}
