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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Existing Category"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypSelection4
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .ypWhite
        return label
    }()
    
    private let heartIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let kvuAleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        label.textColor = .ypBlack
        return label
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        kvuAleteView.translatesAutoresizingMaskIntoConstraints = false
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            cardView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 23),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            heartIcon.widthAnchor.constraint(equalToConstant: 24),
            heartIcon.heightAnchor.constraint(equalToConstant: 24),
            heartIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            heartIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            kvuAleteView.widthAnchor.constraint(equalToConstant: 167),
            kvuAleteView.heightAnchor.constraint(equalToConstant: 58),
            kvuAleteView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            completionButton.topAnchor.constraint(equalTo: kvuAleteView.topAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: kvuAleteView.trailingAnchor, constant: -12),
            
            countLabel.heightAnchor.constraint(equalToConstant: 18),
            countLabel.topAnchor.constraint(equalTo: kvuAleteView.topAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: kvuAleteView.leadingAnchor, constant: 12)
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
        if isCompletedForToday() {
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        let countDays = completedTrackers.count
        var day = ""
        if countDays == 1 {
            day = "День"
        } else if (2...4).contains(countDays) {
            day = "Дня"
        } else {
            day = "Дней"
        }
        countLabel.text = ("\(countDays) \(day)")
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
