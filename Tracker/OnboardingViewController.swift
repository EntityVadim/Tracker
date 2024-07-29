//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import Foundation
import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Отслеживайте только то, что хотите"
        label.font = UIFont(name: "YP-Bold", size: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Даже если это не литры воды и йога"
        label.font = UIFont(name: "YP-Bold", size: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont(name: "YP-Medium", size: 16)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width * 2, height: scrollView.frame.height)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.frame = scrollView.bounds
        
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
        contentView.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        let buttonHeight: CGFloat = 60
        let labelHeight: CGFloat = 76
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            firstLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            firstLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -160),
            firstLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: padding),
            secondLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -84),
            actionButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
