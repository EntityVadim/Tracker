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
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCategory(title: String, trackers: [TrackerEntity]) {
        let categoryObject = TrackerCategoryEntity(context: context)
        categoryObject.title = title
        categoryObject.addToTrackers(NSSet(array: trackers))
        saveContext()
    }
    
    func fetchAllCategories() -> [TrackerCategoryEntity] {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    func deleteCategory(_ category: TrackerCategoryEntity) {
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
