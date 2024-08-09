//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Вадим on 07.08.2024.
//

import UIKit

// MARK: - TrackerCreation

final class TrackerCreationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Public Properties
    
    var trackerType: TrackerType?
    var selectedCategory: String?
    
    // MARK: - Private Properties
    
    private var selectedDays: [WeekDay] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 16
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGrey
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var categoriesButton: UIButton = createCustomButton(
        title: "Категория",
        action: #selector(categoriesButtonTapped))
    
    private lazy var scheduleButton: UIButton = createCustomButton(
        title: "Расписание",
        action: #selector(scheduleButtonTapped))
    
    private let buttonsContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypLightGray
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        if trackerType == .irregularEvent {
            scheduleButton.isHidden = true
            buttonsContainerView.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        [titleLabel,
         nameTextField,
         cancelButton,
         saveButton,
         buttonsContainerView,
         categoriesButton,
         separatorView,
         scheduleButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buttonsContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            buttonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 150),
            
            categoriesButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            categoriesButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            categoriesButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            categoriesButton.heightAnchor.constraint(equalToConstant: 75),
            
            separatorView.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            scheduleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
    
    private func createCustomButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .ypLightGray
        button.setTitleColor(.ypBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: action, for: .touchUpInside)
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = .ypBlack
        button.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        return button
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoriesButtonTapped() {
        let categorySelectionVC = TrackerCategoryViewController()
        present(categorySelectionVC, animated: true, completion: nil)
    }
    
    @objc private func scheduleButtonTapped() {
        let scheduleVC = TrackerScheduleViewController()
        scheduleVC.selectedDays = selectedDays
        scheduleVC.daySelectionHandler = { [weak self] selectedDays in
            self?.selectedDays = selectedDays
        }
        present(scheduleVC, animated: true, completion: nil)
    }
}
