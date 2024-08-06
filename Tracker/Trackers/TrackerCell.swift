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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.addTarget(
            self,
            action: #selector(completionButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(completionButton)
        contentView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            completionButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
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
            completionButton.setTitle("✔️", for: .normal)
        } else {
            completionButton.setTitle("+", for: .normal)
        }
    }
    
    func isCompletedForToday() -> Bool {
        return completedTrackers.contains { $0.trackerId == tracker?.id && $0.date == date }
    }
    
    @objc private func completionButtonTapped() {
        guard let tracker = tracker else { return }
        delegate?.trackerCellDidToggleCompletion(self, for: tracker)
    }
}
