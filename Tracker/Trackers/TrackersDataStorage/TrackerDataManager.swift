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
    
    static let shared = TrackerDataManager()
    let context: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func markTrackerAsCompleted(
        trackerId: UUID,
        date: String) {
            let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "tracker.id == %@ AND date == %@",
                trackerId as CVarArg, date)
            do {
                let records = try context.fetch(fetchRequest)
                if records.isEmpty {
                    let newRecord = TrackerRecordCoreData(context: context)
                    newRecord.tracker = fetchTracker(by: trackerId)
                    newRecord.date = date
                    saveContext()
                }
            } catch {
                print("Failed to fetch records: \(error)")
            }
        }
    
    func unmarkTrackerAsCompleted(
        trackerId: UUID,
        date: String) {
            let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "tracker.id == %@ AND date == %@",
                trackerId as CVarArg, date)
            do {
                let records = try context.fetch(fetchRequest)
                for record in records {
                    context.delete(record)
                }
                saveContext()
            } catch {
                print("Failed to fetch records: \(error)")
            }
        }
    
    func isIrregularEvent(tracker: TrackerCoreData) -> Bool {
        return tracker.schedule?.contains("irregularEvent") ?? false
    }
    
    func isHabit(tracker: TrackerCoreData) -> Bool {
        return tracker.schedule?.contains("habit") ?? false
    }
    
    func addNewTracker(
        to categoryTitle: String,
        tracker: Tracker) {
            let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "title == %@",
                categoryTitle)
            do {
                let categories = try context.fetch(fetchRequest)
                if let category = categories.first {
                    TrackerStore().addTracker(
                        id: tracker.id,
                        name: tracker.name,
                        color: tracker.color,
                        emoji: tracker.emoji,
                        schedule: tracker.schedule,
                        category: category)
                }
            } catch {
                print("Failed to fetch or add category: \(error)")
            }
        }
    
//        func addNewTracker(
//            to categoryTitle: String,
//            tracker: TrackerEntity) {
//                let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
//                fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
//                do {
//                    let categories = try context.fetch(fetchRequest)
//                    if let category = categories.first {
//                        category.addToTrackers(tracker)
//                    } else {
//                        let newCategory = TrackerCategoryEntity(context: context)
//                        newCategory.title = categoryTitle
//                        newCategory.addToTrackers(tracker)
//                    }
//                    saveContext()
//                } catch {
//                    print("Failed to fetch or add category: \(error)")
//                }
//            }
    
    func shouldDisplayTracker(
        _ tracker: TrackerCoreData,
        forDate date: Date,
        dateFormatter: DateFormatter) -> Bool {
            let calendar = Calendar.current
            if isIrregularEvent(tracker: tracker) {
                let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "tracker.id == %@",
                    tracker.id! as any CVarArg as CVarArg)
                do {
                    let records = try context.fetch(fetchRequest)
                    return records.contains { $0.date == dateFormatter.string(from: date) }
                } catch {
                    print("Failed to fetch records: \(error)")
                }
                return true
            } else if isHabit(tracker: tracker) {
                let weekDay = calendar.component(.weekday, from: date)
                let selectDayWeek: WeekDay
                switch weekDay {
                case 1: selectDayWeek = .sunday
                case 2: selectDayWeek = .monday
                case 3: selectDayWeek = .tuesday
                case 4: selectDayWeek = .wednesday
                case 5: selectDayWeek = .thursday
                case 6: selectDayWeek = .friday
                case 7: selectDayWeek = .saturday
                default:
                    fatalError("Unknown weekday")
                }
                return tracker.schedule?.contains(selectDayWeek.rawValue) ?? false
            }
            return false
        }
    
    // MARK: - Private Methods
    
    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch tracker: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
