//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим on 05.09.2024.
//

import Foundation

// MARK: - TrackerCategoryViewModel

final class TrackerCategoryViewModel {
    
    // MARK: - Keys
    
    static let selectedCategory = "selectedCategory"
    
    // MARK: - Public Properties
    
    var updateUI: (() -> Void)?
    var saveCategory: (() -> Void)?
    
    var categories: [TrackerCategory] = [] {
        didSet { updateUI?() }
    }
    var selectedCategory: TrackerCategory? {
        didSet { saveCategory?() }
    }
    
    // MARK: - Private Properties
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Initialization
    
    init() {
        loadCategories()
        loadSelectedCategory()
    }
    
    // MARK: - Public Methods
    
    func addCategory(with title: String) {
        let newCategory = TrackerCategory(title: title, trackers: [])
        trackerCategoryStore.addCategory(title: title, trackers: [])
        categories.append(newCategory)
        selectedCategory = newCategory
    }
    
    func selectCategory(at index: Int) {
        guard index < categories.count else { return }
        let category = categories[index]
        selectedCategory = (category.title == selectedCategory?.title) ? nil : category
    }
    
    // MARK: - Private Methods
    
    private func loadCategories() {
        do {
            categories = try trackerCategoryStore.getCategory()
        } catch {
            print("Сохранение не удалось: \(error)")
        }
    }
    
    private func saveSelectedCategory() {
        UserDefaults.standard.set(
            selectedCategory?.title,
            forKey: TrackerCategoryViewModel.selectedCategory)
    }
    
    private func loadSelectedCategory() {
        guard let title = UserDefaults.standard.string(
            forKey: TrackerCategoryViewModel.selectedCategory
        ) else { return }
        selectedCategory = TrackerCategory(title: title, trackers: [])
    }
}
