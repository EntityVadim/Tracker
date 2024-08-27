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
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []
    
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
    
    func addNewTracker(to categoryTitle: String, tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        do {
            let categories = try context.fetch(fetchRequest)
            if let category = categories.first {
                let existingTrackers = category.trackers?.allObjects as? [TrackerCoreData]
                if existingTrackers?.contains(where: { $0.id == tracker.id }) == true {
                    print("Tracker with id \(tracker.id) already exists in category \(categoryTitle)")
                    return
                }
            }
            let newTracker = TrackerCoreData(context: context)
            newTracker.id = tracker.id
            newTracker.name = tracker.name
            newTracker.color = tracker.color
            newTracker.emoji = tracker.emoji
            newTracker.schedule = tracker.schedule.joined(separator: ",")
            if let category = categories.first {
                category.addToTrackers(newTracker)
            } else {
                let newCategory = TrackerCategoryCoreData(context: context)
                newCategory.title = categoryTitle
                newCategory.addToTrackers(newTracker)
            }
            saveContext()
        } catch {
            print("Failed to fetch or add category: \(error)")
        }
    }
    
    func shouldDisplayTracker(
        _ tracker: Tracker,
        forDate date: Date,
        dateFormatter: DateFormatter) -> Bool {
            guard !tracker.schedule.isEmpty else {
                return true
            }
            let calendar = Calendar.current
            let weekdayIndex = calendar.component(.weekday, from: date) - 1
            let weekdaySymbols = calendar.weekdaySymbols
            _ = weekdaySymbols[weekdayIndex]
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as NSUUID)
            do {
                let trackers = try context.fetch(fetchRequest)
                if let tracker = trackers.first {
                    let calendar = Calendar.current
                    if isIrregularEvent(tracker: tracker) {
                        let fetchRequest:
                        NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
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
            } catch {
                print("Error finding category: \(error)")
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
            if context.hasChanges {
                try context.save()
                print("Context successfully saved.")
            }
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

extension TrackerDataManager {
    func loadCategories() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let fetchedCategories = try context.fetch(fetchRequest)
            self.categories = fetchedCategories.map { categoryCoreData in
                let trackers = (categoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.map {
                    trackerCoreData in
                    return Tracker(
                        id: trackerCoreData.id ?? UUID(),
                        name: trackerCoreData.name ?? "",
                        color: trackerCoreData.color as! UIColor,
                        emoji: trackerCoreData.emoji ?? "",
                        schedule: decodeSchedule(trackerCoreData.schedule))
                } ?? []
                return TrackerCategory(
                    title: categoryCoreData.title ?? "",
                    trackers: trackers)
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    private func decodeSchedule(_ scheduleString: String?) -> [String] {
        guard let data = scheduleString?.data(using: .utf8) else { return [] }
        do {
            let schedule = try JSONDecoder().decode([String].self, from: data)
            return schedule
        } catch {
            print("Failed to decode schedule: \(error)")
            return []
        }
    }
}
