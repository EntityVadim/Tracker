//
//  TrackerModels.swift
//  Tracker
//
//  Created by Вадим on 02.08.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [String]
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let trackerId: UUID
    let date: String
}
