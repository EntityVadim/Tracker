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
    
    // MARK: - Public Properties
    
    @NSManaged public var isPinned: Bool
    static let shared = TrackerDataManager()
    let context: NSManagedObjectContext
    
    // MARK: - Private Properties
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []
    private(set) var previousCategories: [UUID: TrackerCategoryCoreData] = [:]
    
    // MARK: - Initialization
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        loadCompletedTrackers()
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
                    guard let tracker = fetchTracker(by: trackerId) else {
                        print("Tracker not found with id: \(trackerId)")
                        return
                    }
                    let newRecord = TrackerRecordCoreData(context: context)
                    newRecord.tracker = tracker
                    newRecord.trackerId = tracker.id
                    newRecord.date = date
                    saveContext()
                    let trackerRecord = TrackerRecord(coreData: newRecord)
                    completedTrackers.append(trackerRecord)
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
                completedTrackers.removeAll { $0.trackerId == trackerId && $0.date == date }
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
            if let jsonData = try? JSONEncoder().encode(tracker.schedule) {
                newTracker.schedule = String(data: jsonData, encoding: .utf8)
            } else {
                print("Failed to encode schedule to JSON.")
            }
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
            let calendar = Calendar.current
            if tracker.schedule.contains("irregularEvent") {
                let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "tracker.id == %@ AND date == %@",
                    tracker.id as CVarArg, dateFormatter.string(from: date)
                )
                do {
                    let records = try context.fetch(fetchRequest)
                    if records.isEmpty {
                        let trackerCreatedRecently = !completedTrackers.contains { $0.trackerId == tracker.id }
                        return trackerCreatedRecently
                    }
                    return !records.isEmpty
                } catch {
                    print("Ошибка при запросе данных: \(error)")
                    return false
                }
            }
            let weekdayIndex = calendar.component(.weekday, from: date) - 1
            let weekdaySymbols = calendar.weekdaySymbols
            _ = weekdaySymbols[weekdayIndex]
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as NSUUID)
            do {
                let trackers = try context.fetch(fetchRequest)
                if let fetchedTracker = trackers.first {
                    if isHabit(tracker: fetchedTracker) {
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
                            fatalError("Неизвестный день недели")
                        }
                        let isScheduledToday = fetchedTracker.schedule?.contains(selectDayWeek.rawValue) ?? false
                        return isScheduledToday
                    }
                }
            } catch {
                print("Ошибка при запросе данных: \(error)")
            }
            return false
        }
    
    func pinTracker(_ tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            if let trackerToPin = try context.fetch(fetchRequest).first {
                trackerToPin.isPinned = true
                previousCategories[tracker.id] = trackerToPin.category
                let pinnedCategory = fetchPinnedCategory()
                trackerToPin.category = pinnedCategory
                saveContext()
            }
        } catch {
            print("Failed to pin tracker: \(error)")
        }
    }
    
    func unpinTracker(_ tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            if let trackerToUnpin = try context.fetch(fetchRequest).first {
                trackerToUnpin.isPinned = false
                if let previousCategory = previousCategories[tracker.id] {
                    trackerToUnpin.category = previousCategory
                } else {
                    print("Previous category for tracker \(tracker.id) not found")
                }
                previousCategories[tracker.id] = nil
                saveContext()
            }
        } catch {
            print("Failed to unpin tracker: \(error)")
        }
    }
    
    func isTrackerPinned(_ tracker: Tracker) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            if let fetchedTracker = try context.fetch(fetchRequest).first {
                return fetchedTracker.isPinned
            }
        } catch {
            print("Failed to check if tracker is pinned: \(error)")
        }
        return false
    }
    
    func deleteTracker(withId id: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let trackers = try context.fetch(fetchRequest)
            if let trackerToDelete = trackers.first {
                TrackerStore().deleteTracker(trackerToDelete)
                loadCategories()
            }
        } catch {
            print("Failed to fetch or delete tracker: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    func fetchPinnedCategory() -> TrackerCategoryCoreData {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", "Закрепленные")
        do {
            if let pinnedCategory = try context.fetch(fetchRequest).first {
                return pinnedCategory
            } else {
                let newPinnedCategory = TrackerCategoryCoreData(context: context)
                newPinnedCategory.title = "Закрепленные"
                saveContext()
                return newPinnedCategory
            }
        } catch {
            fatalError("Не удалось получить или создать категорию Закрепленные: \(error)")
        }
    }
    
    private func loadCompletedTrackers() {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let records = try context.fetch(fetchRequest)
            self.completedTrackers = records.map { TrackerRecord(coreData: $0) }
        } catch {
            print("Failed to fetch completed trackers: \(error)")
        }
    }
    
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
            }
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

// MARK: - TrackerDataManager

extension TrackerDataManager {
    func loadCategories() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let fetchedCategories = try context.fetch(fetchRequest)
            self.categories = fetchedCategories.compactMap { categoryCoreData in
                let trackers = (categoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.map {
                    trackerCoreData in
                    return Tracker(
                        id: trackerCoreData.id ?? UUID(),
                        name: trackerCoreData.name ?? "",
                        color: trackerCoreData.color as! UIColor,
                        emoji: trackerCoreData.emoji ?? "",
                        schedule: decodeSchedule(trackerCoreData.schedule))
                } ?? []
                return trackers.isEmpty ? nil : TrackerCategory(
                    title: categoryCoreData.title ?? "",
                    trackers: trackers)
            }
            self.categories.sort { category1, category2 in
                if category1.title == "Закрепленные" {
                    return true
                } else if category2.title == "Закрепленные" {
                    return false
                } else {
                    return category1.title < category2.title
                }
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
