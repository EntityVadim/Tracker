//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Created by Вадим on 10.08.2024.
//

import UIKit

// MARK: - TrackerSectionHeader

final class TrackerSectionHeader: UICollectionReusableView {
    
    // MARK: - Identifier
    
    static let trackerSectionHeaderIdentifier = "TrackerSectionHeader"
    
    // MARK: - UI Elements
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
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
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
        ])
    }
}
