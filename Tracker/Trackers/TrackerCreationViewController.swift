//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Вадим on 07.08.2024.
//

import UIKit

// MARK: - TrackerCreationDelegate

protocol TrackerCreationDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, inCategory category: String)
}

// MARK: - TrackerCreation

final class TrackerCreationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCreationDelegate?
    var trackerType: TrackerType?
    var selectedCategory: String?
    
    // MARK: - Private Properties
    
    private var selectedDays: [WeekDay] = []
    private let dataManager = TrackerDataManager()
    
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
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
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
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var categoriesButton: UIButton = createRoundedButton(
        title: "Категория",
        action: #selector(categoriesButtonTapped),
        corners: [.topLeft, .topRight],
        radius: 16
    )
    
    private lazy var scheduleButton: UIButton = createRoundedButton(
        title: "Расписание",
        action: #selector(scheduleButtonTapped),
        corners: [.bottomLeft, .bottomRight],
        radius: 16
    )
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        
        if trackerType == .irregularEvent {
            scheduleButton.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        [titleLabel,
         nameTextField,
         cancelButton,
         saveButton,
         categoriesButton,
         separatorView,
         scheduleButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoriesButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoriesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            scheduleButton.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
    
    private func createRoundedButton(
        title: String,
        action: Selector,
        corners: UIRectCorner,
        radius: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 75).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .ypLightGray
        button.setTitleColor(.ypBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: action, for: .touchUpInside)
        let buttonWidth = UIScreen.main.bounds.width - 32
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: buttonWidth, height: 75),
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        button.layer.mask = mask
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
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let selectedCategory = selectedCategory else {
            return
        }
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: .ypSelection4,
            emoji: "😡",
            schedule: selectedDays.map { $0.rawValue }
        )
        dataManager.addNewTracker(to: selectedCategory, tracker: newTracker)
        delegate?.didCreateTracker(newTracker, inCategory: selectedCategory)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoriesButtonTapped() {
        let categorySelectionVC = TrackerCategoryViewController()
        categorySelectionVC.categorySelectionHandler = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            self?.categoriesButton.setTitle(selectedCategory, for: .normal)
        }
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
