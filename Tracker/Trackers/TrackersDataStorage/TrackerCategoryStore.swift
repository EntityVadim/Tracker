//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Вадим on 11.08.2024.
//

import CoreData
import UIKit

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

final class TrackerCategoryStore {
    private let context = TrackerDataManager.shared.context
    
    func addCategory(title: String, trackers: [TrackerCoreData]) {
        let categoryObject = TrackerCategoryCoreData(context: context)
        categoryObject.title = title
        categoryObject.addToTrackers(NSSet(array: trackers))
        saveContext()
    }
    
    func getCategory() throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreDate")
        do {
            let authors = try context.fetch(request)
            authors.forEach { categories.append(TrackerCategory(title: $0.title!, trackers: [])) }
        } catch {
            throw error
        }
        return categories
    }
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        context.delete(category)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
