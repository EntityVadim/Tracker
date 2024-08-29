//
//  TrackerCell.swift
//  Tracker
//
//  Created by Вадим on 06.08.2024.
//

import UIKit

// MARK: - TrackerCellDelegate

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidToggleCompletion(_ cell: TrackerCell, for tracker: Tracker)
}

// MARK: - TrackerCell

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let trackerCellIdentifier = "TrackerCell"
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    
    private var tracker: Tracker?
    private var completedTrackers: [TrackerRecord] = []
    private var date: String = ""
    private var dataManager: TrackerDataManager?
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .ypWhite
        return label
    }()
    
    private let quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus")
        button.setImage(plusImage, for: .normal)
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
        contentView.addSubview(quantityView)
        quantityView.addSubview(completionButton)
        quantityView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 90),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            quantityView.heightAnchor.constraint(equalToConstant: 58),
            quantityView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            completionButton.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -12),
            
            countLabel.heightAnchor.constraint(equalToConstant: 18),
            countLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: 12)
        ])
    }
    
    private func updateCompletionButtonSaturation(forCompletedState isCompleted: Bool) {
        if isCompleted {
            completionButton.backgroundColor = tracker?.color.withAlphaComponent(0.3)
        } else {
            completionButton.backgroundColor = tracker?.color
        }
    }
    
    // MARK: - Configuration
    
    func configure(
        with tracker: Tracker,
        completedTrackers: [TrackerRecord],
        dataManager: TrackerDataManager,
        date: String) {
            self.tracker = tracker
            self.completedTrackers = completedTrackers
            self.dataManager = dataManager
            self.date = date
            cardView.backgroundColor = tracker.color
            emojiLabel.text = tracker.emoji
            nameLabel.text = tracker.name
            updateCompletionButtonSaturation(forCompletedState: isCompletedForToday())
            let uniqueDates = Set(completedTrackers.map { $0.date })
            let countDays = uniqueDates.count
            let day: String
            switch countDays {
            case 1:
                day = "День"
            case 2...4:
                day = "Дня"
            default:
                day = "Дней"
            }
            countLabel.text = "\(countDays) \(day)"
            let configuration = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
            let iconName = isCompletedForToday() ? "checkmark" : "plus"
            let iconImage = UIImage(systemName: iconName, withConfiguration: configuration)
            completionButton.setImage(iconImage, for: .normal)
        }
    
    // MARK: - Helper Methods
    
    func isCompletedForToday() -> Bool {
        return completedTrackers.contains { $0.trackerId == tracker?.id && $0.date == date }
    }
    
    // MARK: - Action
    
    @objc func completionButtonTapped() {
        guard let tracker = tracker else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        guard let selectedDate = dateFormatter.date(from: date), selectedDate <= Date() else {
            return
        }
        if isCompletedForToday() {
            dataManager?.unmarkTrackerAsCompleted(trackerId: tracker.id, date: date)
        } else {
            dataManager?.markTrackerAsCompleted(trackerId: tracker.id, date: date)
        }
        updateCompletionButtonSaturation(forCompletedState: !isCompletedForToday())
        delegate?.trackerCellDidToggleCompletion(self, for: tracker)
    }
}
