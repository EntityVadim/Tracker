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
    private var dataManager: TrackerDataManager?
    
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
    
    private let quantityView: UIView = {
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
    
    // MARK: - Configuration
    
    func configure(
        with tracker: Tracker,
        completedTrackers: [TrackerRecord],
        dataManager: TrackerDataManager) {
            self.tracker = tracker
            self.completedTrackers = completedTrackers
            self.dataManager = dataManager
            emojiLabel.text = tracker.emoji
            nameLabel.text = tracker.name
            cardView.backgroundColor = tracker.color
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            date = dateFormatter.string(from: Date())
            let countDays = completedTrackers.count
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
            completionButton.setImage(UIImage(
                systemName: isCompletedForToday() ? "checkmark" : "plus"), for: .normal)
        }
    
    // MARK: - Helper Methods
    
    func isCompletedForToday() -> Bool {
        return completedTrackers.contains { $0.trackerId == tracker?.id && $0.date == date }
    }
    
    // MARK: - Button Action
    
    @objc func completionButtonTapped() {
        guard let tracker = tracker else { return }
        if isCompletedForToday() {
            dataManager?.unmarkTrackerAsCompleted(trackerId: tracker.id, date: date)
        } else {
            dataManager?.markTrackerAsCompleted(trackerId: tracker.id, date: date)
        }
//        completionButton.setImage(UIImage(systemName: isCompletedForToday() ? "checkmark" : "plus"), for: .normal)
        delegate?.trackerCellDidToggleCompletion(self, for: tracker)
    }
}
