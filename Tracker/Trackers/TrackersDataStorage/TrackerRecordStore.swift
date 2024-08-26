//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Вадим on 11.08.2024.
//

import CoreData
import UIKit

struct TrackerRecord {
    let trackerId: UUID
    let date: String
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addRecord(date: String, tracker: TrackerEntity) {
        let recordObject = TrackerRecordEntity(context: context)
        recordObject.date = date
        recordObject.tracker = tracker
        saveContext()
    }
    
    func fetchRecords(for tracker: TrackerEntity) -> [TrackerRecordEntity] {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch records: \(error)")
            return []
        }
    }
    
    func deleteRecord(_ record: TrackerRecordEntity) {
        context.delete(record)
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
