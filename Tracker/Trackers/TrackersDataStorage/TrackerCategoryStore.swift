//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Вадим on 11.08.2024.
//

import CoreData
import UIKit

// MARK: - TrackerCategoryModels

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore {
    
    // MARK: - Private Properties
    
    private let context = TrackerDataManager.shared.context
    
    // MARK: - Public Methods
    
    func addCategory(title: String, trackers: [TrackerCoreData]) {
        let categoryObject = TrackerCategoryCoreData(context: context)
        categoryObject.title = title
        categoryObject.addToTrackers(NSSet(array: trackers))
        saveContext()
    }
    
    func getCategory() throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let authors = try context.fetch(request)
            authors.forEach {
                if let title = $0.title {
                    categories.append(TrackerCategory(title: title, trackers: []))
                } else {
                    print("Warning: TrackerCategoryCoreData object with nil title found.")
                }
            }
        } catch {
            throw error
        }
        return categories
    }
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        context.delete(category)
        saveContext()
    }
    
    // MARK: - Private Methods
    
    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
                print("Context successfully saved.")
            }
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
