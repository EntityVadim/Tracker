//
//  EmojiCell.swift
//  Tracker
//
//  Created by Вадим on 16.08.2024.
//

import UIKit

// MARK: - EmojiCell

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let reuseIdentifier = "emojiCell"
    
    // MARK: - Private Properties
    
    private let emojiContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiContainer)
        emojiContainer.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? UIColor.ypLightGray : .clear
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiContainer.widthAnchor.constraint(equalToConstant: 32),
            emojiContainer.heightAnchor.constraint(equalToConstant: 32),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
