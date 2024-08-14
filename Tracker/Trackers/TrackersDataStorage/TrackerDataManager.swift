//
//  TrackerDataManager.swift
//  Tracker
//
//  Created by Вадим on 10.08.2024.
//

import UIKit

// MARK: - TrackerDataManager

final class TrackerDataManager {
    
    // MARK: - Private Properties
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Public Methods
    
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
    
    func isIrregularEvent(tracker: Tracker) -> Bool {
        return tracker.schedule.contains("irregularEvent")
    }
    
    func isHabit(tracker: Tracker) -> Bool {
        return tracker.schedule.contains("habit")
    }
    
    func addNewTracker(to categoryTitle: String, tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            var updatedTrackers = categories[index].trackers
            updatedTrackers.append(tracker)
            let updatedCategory = TrackerCategory(
                title: categories[index].title,
                trackers: updatedTrackers
            )
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
    }
    
    func shouldDisplayTracker(_ tracker: Tracker, forDate date: Date, dateFormatter: DateFormatter) -> Bool {
        if isIrregularEvent(tracker: tracker) {
            let recordExists = completedTrackers.contains {
                $0.trackerId == tracker.id && $0.date == dateFormatter.string(from: date)
            }
            return recordExists || !recordExists
        } else if isHabit(tracker: tracker) {
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: date)
            var selectDayWeek: WeekDay
            switch weekDay {
            case 1: selectDayWeek = .sunday
            case 2: selectDayWeek = .monday
            case 3: selectDayWeek = .tuesday
            case 4: selectDayWeek = .wednesday
            case 5: selectDayWeek = .thursday
            case 6: selectDayWeek = .friday
            case 7: selectDayWeek = .saturday
            default:
                fatalError("Неизвестный день недели")
            }
            return tracker.schedule.contains(selectDayWeek.rawValue)
        }
        return false
    }
}
