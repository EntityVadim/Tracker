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
    var selectedEmoji: String?
    var selectedColor: UIColor?
    
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                  "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                  "🥦", "🏓", "🥇", "🎸", "🌴", "😪"]
    
    let colors: [UIColor] = [.ypSelection1, .ypSelection2, .ypSelection3, .ypSelection4,
                             .ypSelection5, .ypSelection6, .ypSelection7, .ypSelection8,
                             .ypSelection9, .ypSelection10, .ypSelection11, .ypSelection12,
                             .ypSelection13, .ypSelection14, .ypSelection15, .ypSelection16,
                             .ypSelection17, .ypSelection18]
    
    lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private var selectedDays: [WeekDay] = []
    private let dataManager = TrackerDataManager()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
        textField.backgroundColor = .ypBackgroundDay
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
    
    private lazy var categoriesButton: UIButton = {
        let button = createRoundedButton (
            title: "Категория",
            action: #selector(categoriesButtonTapped),
            corners: [.topLeft, .topRight],
            radius: 16
        )
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = createRoundedButton(
            title: "Расписание",
            action: #selector(scheduleButtonTapped),
            corners: [.bottomLeft, .bottomRight],
            radius: 16
        )
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        return button
    }()
    
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
        updateSaveButtonState()
        updateLayoutForTrackerType()
        
        if trackerType == .irregularEvent {
            scheduleButton.isHidden = true
            separatorView.isHidden = true
            updateCategoriesButtonCorners(.allCorners, radius: 16)
        } else {
            updateCategoriesButtonCorners([.topLeft, .topRight], radius: 16)
        }
        
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
    }
    
    // MARK: - Public Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateSaveButtonState()
        return true
    }
    
    func updateSaveButtonState() {
        let isNameFilled = !(nameTextField.text?.isEmpty ?? true)
        let isCategorySelected = selectedCategory != nil
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        if isNameFilled && isCategorySelected && isEmojiSelected && isColorSelected {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .ypBlack
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .ypGrey
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        [titleLabel,
         nameTextField,
         emojiLabel,
         emojiCollectionView,
         colorLabel,
         colorCollectionView,
         categoriesButton,
         separatorView,
         scheduleButton,
         cancelButton,
         saveButton].forEach {
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
            categoriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            scheduleButton.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: calculateCellSize()),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: calculateCellSize()),
            
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
            button.backgroundColor = .ypBackgroundDay
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
            button.backgroundColor = .ypBackgroundDay
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
    
    private func updateCategoriesButtonCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let buttonWidth = UIScreen.main.bounds.width - 32
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: buttonWidth, height: 75),
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        categoriesButton.layer.mask = mask
        categoriesButton.backgroundColor = .ypBackgroundDay
    }
    
    private func updateCategoriesButtonTitle() {
        let titleText = NSMutableAttributedString(string: "Категория\n", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.ypBlack
        ])
        if let categoryText = selectedCategory {
            let categoryAttributedText = NSAttributedString(string: categoryText, attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor.ypGrey
            ])
            titleText.append(categoryAttributedText)
        }
        categoriesButton.setAttributedTitle(titleText, for: .normal)
    }
    
    private func updateScheduleButtonTitle() {
        let weekDayShortNames = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let titleText = NSMutableAttributedString(string: "Расписание\n", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.ypBlack
        ])
        var daysText: String
        if selectedDays.count == WeekDay.allCases.count {
            daysText = "Каждый день"
        } else {
            let shortNames = selectedDays.map { weekDayShortNames[WeekDay.allCases.firstIndex(of: $0)!] }
            daysText = shortNames.joined(separator: ", ")
        }
        let daysAttributedText = NSAttributedString(string: daysText, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.ypGrey
        ])
        titleText.append(daysAttributedText)
        scheduleButton.setAttributedTitle(titleText, for: .normal)
    }
    
    private func updateLayoutForTrackerType() {
        if trackerType == .habit {
            NSLayoutConstraint.activate([
                emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32)
            ])
        } else if trackerType == .irregularEvent {
            NSLayoutConstraint.activate([
                emojiLabel.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor, constant: 32)
            ])
        }
    }
    
    private func calculateCellSize() -> CGFloat {
        let width = view.frame.width
        let height: CGFloat
        let heightCell = width / 6
        height = heightCell * 3
        return height
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let selectedCategory = selectedCategory else { return }
        guard let selectedEmoji = selectedEmoji else { return }
        guard let selectedColor = selectedColor else { return }
        var schedule = selectedDays.map { $0.rawValue }
        if trackerType == .irregularEvent {
            schedule.append("irregularEvent")
        } else {
            schedule.append("habit")
        }
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: schedule
        )
        dataManager.addNewTracker(to: selectedCategory, tracker: newTracker)
        delegate?.didCreateTracker(newTracker, inCategory: selectedCategory)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoriesButtonTapped() {
        let categorySelectionVC = TrackerCategoryViewController()
        categorySelectionVC.categorySelectionHandler = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            self?.updateCategoriesButtonTitle()
            self?.updateSaveButtonState()
        }
        present(categorySelectionVC, animated: true, completion: nil)
    }
    
    @objc private func scheduleButtonTapped() {
        let scheduleVC = TrackerScheduleViewController()
        scheduleVC.selectedDays = selectedDays
        scheduleVC.daySelectionHandler = { [weak self] selectedDays in
            self?.selectedDays = selectedDays
            self?.updateScheduleButtonTitle()
            self?.updateSaveButtonState()
        }
        present(scheduleVC, animated: true, completion: nil)
    }
}
