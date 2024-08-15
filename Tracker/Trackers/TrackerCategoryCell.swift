//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Вадим on 09.08.2024.
//

import UIKit

// MARK: - TrackerCategoryCell

final class TrackerCategoryCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .ypBlue
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Configuration
    
    func configure(with category: String, isSelected: Bool) {
        textLabel?.text = category
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        checkmarkImageView.isHidden = !isSelected
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
