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
    case track
    case filter
    case edit
    case delete
}

// MARK: - AppMetricaCore

struct AppMetricaCore {
    private static let apiKey = "e04b57c6-b7ad-4740-b897-e5c90606bf1e"
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: apiKey) else { return }
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
