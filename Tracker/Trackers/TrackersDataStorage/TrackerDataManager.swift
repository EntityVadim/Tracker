//
//  TrackerDataManager.swift
//  Tracker
//
//  Created by Вадим on 10.08.2024.
//

import CoreData
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
        let calendar = Calendar.current
        if isIrregularEvent(tracker: tracker) {
            if completedTrackers.contains(where: { $0.trackerId == tracker.id }) {
                let recordExists = completedTrackers.contains {
                    $0.trackerId == tracker.id && $0.date == dateFormatter.string(from: date)
                }
                return recordExists
            }
            return true
        } else if isHabit(tracker: tracker) {
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


//// MARK: - TrackerDataManager
//
//final class TrackerDataManager {
//    
//    // MARK: - Private Properties
//    
//    private let context: NSManagedObjectContext
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    // MARK: - Public Methods
//    
//    func markTrackerAsCompleted(
//        trackerId: UUID,
//        date: String) {
//            let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerId as CVarArg, date)
//            do {
//                let records = try context.fetch(fetchRequest)
//                if records.isEmpty {
//                    let newRecord = TrackerRecordEntity(context: context)
//                    newRecord.tracker = fetchTracker(by: trackerId)
//                    newRecord.date = date
//                    saveContext()
//                }
//            } catch {
//                print("Failed to fetch records: \(error)")
//            }
//        }
//    
//    func unmarkTrackerAsCompleted(
//        trackerId: UUID,
//        date: String) {
//            let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(
//                format: "tracker.id == %@ AND date == %@",
//                trackerId as CVarArg, date)
//            do {
//                let records = try context.fetch(fetchRequest)
//                for record in records {
//                    context.delete(record)
//                }
//                saveContext()
//            } catch {
//                print("Failed to fetch records: \(error)")
//            }
//        }
//    
//    func isIrregularEvent(tracker: TrackerEntity) -> Bool {
//        return tracker.schedule?.contains("irregularEvent") ?? false
//    }
//    
//    func isHabit(tracker: TrackerEntity) -> Bool {
//        return tracker.schedule?.contains("habit") ?? false
//    }
//    
//    func addNewTracker(
//        to categoryTitle: String,
//        tracker: TrackerEntity) {
//            let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
//            do {
//                let categories = try context.fetch(fetchRequest)
//                if let category = categories.first {
//                    category.addToTrackers(tracker)
//                } else {
//                    let newCategory = TrackerCategoryEntity(context: context)
//                    newCategory.title = categoryTitle
//                    newCategory.addToTrackers(tracker)
//                }
//                saveContext()
//            } catch {
//                print("Failed to fetch or add category: \(error)")
//            }
//        }
//    
//    func shouldDisplayTracker(
//        _ tracker: TrackerEntity,
//        forDate date: Date,
//        dateFormatter: DateFormatter) -> Bool {
//            let calendar = Calendar.current
//            if isIrregularEvent(tracker: tracker) {
//                let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
//                fetchRequest.predicate = NSPredicate(
//                    format: "tracker.id == %@",
//                    tracker.id! as any CVarArg as CVarArg)
//                do {
//                    let records = try context.fetch(fetchRequest)
//                    return records.contains { $0.date == dateFormatter.string(from: date) }
//                } catch {
//                    print("Failed to fetch records: \(error)")
//                }
//                return true
//            } else if isHabit(tracker: tracker) {
//                let weekDay = calendar.component(.weekday, from: date)
//                let selectDayWeek: WeekDay
//                switch weekDay {
//                case 1: selectDayWeek = .sunday
//                case 2: selectDayWeek = .monday
//                case 3: selectDayWeek = .tuesday
//                case 4: selectDayWeek = .wednesday
//                case 5: selectDayWeek = .thursday
//                case 6: selectDayWeek = .friday
//                case 7: selectDayWeek = .saturday
//                default:
//                    fatalError("Unknown weekday")
//                }
//                return tracker.schedule?.contains(selectDayWeek.rawValue) ?? false
//            }
//            return false
//        }
//    
//    // MARK: - Private Methods
//    
//    private func fetchTracker(by id: UUID) -> TrackerEntity? {
//        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            return try context.fetch(fetchRequest).first
//        } catch {
//            print("Failed to fetch tracker: \(error)")
//            return nil
//        }
//    }
//    
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//}
