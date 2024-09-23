//
//  AppMetrica.swift
//  Tracker
//
//  Created by Вадим on 22.09.2024.
//

import AppMetricaCore
import Foundation

// MARK: - Event

enum Event: String {
    case open, close, click
}

// MARK: - Screen

enum Screen: String {
    case Main, Creation, Category
}

// MARK: - Item

enum Item: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

// MARK: - AppMetricaCore

struct AppMetricaCore {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "e04b57c6-b7ad-4740-b897-e5c90606bf1e")
        else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func sendEvent(event: Event, screen: Screen, item: Item?) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if let item {
            params["item"] = item.rawValue
        }
        AppMetrica.reportEvent(name: event.rawValue, parameters: params)
    }
}
