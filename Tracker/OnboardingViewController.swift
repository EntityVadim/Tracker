//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import Foundation
import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private Properties
    
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
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return button
    }()
    
    private let firstScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "OnboardingBlue")!)
        return view
    }()
    
    private let secondScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "OnboardingRed")!)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.height)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width * 2, height: scrollView.frame.height)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(firstScreenView)
        contentView.addSubview(secondScreenView)
        firstScreenView.addSubview(firstLabel)
        secondScreenView.addSubview(secondLabel)
        contentView.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        let buttonHeight: CGFloat = 60
        let labelHeight: CGFloat = 76
        
        firstScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstScreenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstScreenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            firstScreenView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        secondScreenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondScreenView.leadingAnchor.constraint(equalTo: firstScreenView.trailingAnchor),
            secondScreenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondScreenView.widthAnchor.constraint(equalTo: view.widthAnchor),
            secondScreenView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: firstScreenView.leadingAnchor, constant: padding),
            firstLabel.trailingAnchor.constraint(equalTo: firstScreenView.trailingAnchor, constant: -padding),
            firstLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -160),
            firstLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLabel.leadingAnchor.constraint(equalTo: secondScreenView.leadingAnchor, constant: padding),
            secondLabel.trailingAnchor.constraint(equalTo: secondScreenView.trailingAnchor, constant: -padding),
            secondLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -160),
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
