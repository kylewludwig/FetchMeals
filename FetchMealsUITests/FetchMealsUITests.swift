//
//  FetchMealsUITests.swift
//  FetchMealsUITests
//
//  Created by Kyle Ludwig on 5/22/24.
//

import XCTest

final class FetchMealsUITests: XCTestCase {
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
