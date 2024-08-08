//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Вадим on 07.08.2024.
//

import UIKit

final class TrackerCreationViewController: UIViewController, UITextFieldDelegate {
    
    var trackerType: TrackerType?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .ypWhite
    }
    
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
            
            buttonsContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            buttonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoriesButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: 16),
            categoriesButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16),
            categoriesButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16),
            categoriesButton.heightAnchor.constraint(equalToConstant: 50),
            
            separatorView.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            scheduleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            scheduleButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 50),
            scheduleButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor, constant: -16),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoriesButtonTapped() {
    }
    
    @objc private func scheduleButtonTapped() {
    }
}
