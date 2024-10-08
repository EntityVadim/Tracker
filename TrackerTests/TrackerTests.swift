//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Вадим on 21.09.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackerViewController()
        vc.loadViewIfNeeded()
        assertSnapshot(of: vc, as: .image)
    }
}
