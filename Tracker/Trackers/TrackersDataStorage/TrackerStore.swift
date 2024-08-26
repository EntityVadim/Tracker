//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим on 02.08.2024.
//

import CoreData
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [String]
}

final class TrackerStore {
    private let context = TrackerDataManager.shared.context
    
    func addTracker(
        id: UUID,
        name: String,
        color: UIColor,
        emoji: String,
        schedule: [String],
        category: TrackerCategoryCoreData) {
            let trackerObject = TrackerCoreData(context: context)
            trackerObject.id = id
            trackerObject.name = name
            trackerObject.color = color
            trackerObject.emoji = emoji
            if let jsonData = try? JSONEncoder().encode(schedule) {
                trackerObject.schedule = String(data: jsonData, encoding: .utf8)
            }
            trackerObject.category = category
            saveContext()
        }
    
    func fetchAllTrackers() -> [TrackerCoreData] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        do {
            let trackers = try context.fetch(request)
            trackers.forEach { tracker in
                if let scheduleData = tracker.schedule?.data(using: .utf8),
                   let scheduleArray = try? JSONDecoder().decode([String].self, from: scheduleData) {
                    print("Schedule for \(String(describing: tracker.name)): \(scheduleArray)")
                }
            }
            return trackers
        } catch {
            print("Failed to fetch trackers: \(error)")
            return []
        }
    }
    
    func deleteTracker(_ tracker: TrackerCoreData) {
        context.delete(tracker)
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
