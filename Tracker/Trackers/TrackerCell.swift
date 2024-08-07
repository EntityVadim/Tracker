//
//  TrackerCell.swift
//  Tracker
//
//  Created by Вадим on 06.08.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidToggleCompletion(_ cell: TrackerCell, for tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    private var tracker: Tracker?
    private var completedTrackers: [TrackerRecord] = []
    private var date: String = ""
    
    // UI Elements
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypSelection4
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let heartIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .red
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .ypBlack
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = cardView.backgroundColor
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let kvuAleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)
        cardView.addSubview(heartIcon)
        cardView.addSubview(titleLabel)
        contentView.addSubview(kvuAleteView)
        kvuAleteView.addSubview(completionButton)
        kvuAleteView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        kvuAleteView.translatesAutoresizingMaskIntoConstraints = false
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            
            heartIcon.widthAnchor.constraint(equalToConstant: 24),
            heartIcon.heightAnchor.constraint(equalToConstant: 24),
            heartIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            heartIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            titleLabel.widthAnchor.constraint(equalToConstant: 143),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            kvuAleteView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            kvuAleteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            kvuAleteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            kvuAleteView.heightAnchor.constraint(equalToConstant: 58),
            
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            completionButton.topAnchor.constraint(equalTo: kvuAleteView.topAnchor, constant: 8),
            completionButton.leadingAnchor.constraint(equalTo: kvuAleteView.leadingAnchor, constant: 121),
            
            countLabel.topAnchor.constraint(equalTo: completionButton.bottomAnchor, constant: 8),
            countLabel.centerXAnchor.constraint(equalTo: completionButton.centerXAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with tracker: Tracker, completedTrackers: [TrackerRecord]) {
        self.tracker = tracker
        self.completedTrackers = completedTrackers
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        date = dateFormatter.string(from: Date())
        let completedCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        countLabel.text = "Count: \(completedCount)"
        if isCompletedForToday() {
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    // MARK: - Helper Methods
    
    func isCompletedForToday() -> Bool {
        return completedTrackers.contains { $0.trackerId == tracker?.id && $0.date == date }
    }
    
    // MARK: - Button Action
    
    @objc func completionButtonTapped() {
        guard let tracker = tracker else { return }
        delegate?.trackerCellDidToggleCompletion(self, for: tracker)
    }
}
