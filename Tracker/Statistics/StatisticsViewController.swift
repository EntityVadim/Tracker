//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Вадим on 29.07.2024.
//

import UIKit

// MARK: - StatisticsViewController

final class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "statistics_title",
            comment: "Заголовок экрана статистики")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.ypSelection3.cgColor,
            UIColor.ypSelection9.cgColor,
            UIColor.ypSelection1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90)
        view.layer.addSublayer(gradientLayer)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        let maskLayer = CAShapeLayer()
        let outerPath = UIBezierPath(roundedRect: CGRect(
            x: 0, y: 0,
            width: self.view.bounds.width - 32,
            height: 90), cornerRadius: 16)
        let innerPath = UIBezierPath(roundedRect: CGRect(
            x: 1, y: 1,
            width: self.view.bounds.width - 34,
            height: 88), cornerRadius: 15)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
        [firstLabel, secondLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ErrorStat"))
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "statistics_placeholder",
            comment: "Текст-заполнитель, когда нет данных для анализа")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [titleLabel, gradientView, errorImageView, placeholderLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            gradientView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gradientView.heightAnchor.constraint(equalToConstant: 90),
            
            firstLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12),
            firstLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            firstLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -12),
            
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor),
            secondLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            secondLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -12),
            secondLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12),
            
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
