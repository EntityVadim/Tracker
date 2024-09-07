//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Вадим on 09.08.2024.
//

import UIKit

// MARK: - TrackerCategoryCell

final class TrackerCategoryCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "CustomCategoryCell"
    
    // MARK: - UI Elements
    
    private lazy var checkmarkImageView: UIImageView = {
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
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
