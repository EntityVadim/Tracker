//
//  TrackerDataManager.swift
//  Tracker
//
//  Created by Вадим on 10.08.2024.
//

import UIKit

final class TrackerDataManager {
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []
    
    func markTrackerAsCompleted(trackerId: UUID, date: String) {
        let recordExists = completedTrackers.contains { $0.trackerId == trackerId && $0.date == date }
        if !recordExists {
            let record = TrackerRecord(trackerId: trackerId, date: date)
            completedTrackers.append(record)
        }
    }
    
    func unmarkTrackerAsCompleted(trackerId: UUID, date: String) {
        completedTrackers.removeAll { $0.trackerId == trackerId && $0.date == date }
    }
    
    func addNewTracker(to categoryTitle: String, tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let updatedCategory = TrackerCategory(
                title: categories[index].title,
                trackers: categories[index].trackers + [tracker]
            )
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
    }
}
