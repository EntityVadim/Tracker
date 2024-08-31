//
//  EmojiCell.swift
//  Tracker
//
//  Created by Вадим on 16.08.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    static let reuseIdentifier = "emojiCell"
    
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiContainer.widthAnchor.constraint(equalToConstant: 32),
            emojiContainer.heightAnchor.constraint(equalToConstant: 32),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? UIColor.ypLightGray : .clear
    }
}
