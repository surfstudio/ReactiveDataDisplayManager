//
//  ReactiveDataDisplayManagerExampleUITests.swift
//  
//
//  Created by Artem Kayumov on 19.05.2022./
//

import XCTest

class ReactiveDataDisplayManagerExampleUITests: BaseUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = true
    }

    func testCollectionScreen() throws {
        setTab("Collection")
        try assertAllScreensOpeningWithoutCrashes()
    }

    func testTableScreen() throws {
        setTab("Table")
        try assertAllScreensOpeningWithoutCrashes()
    }

    func testStackScreen() throws {
        setTab("Stack")
        try assertAllScreensOpeningWithoutCrashes()
    }
}

// MARK: - Private methods

private extension ReactiveDataDisplayManagerExampleUITests {

    func assertAllScreensOpeningWithoutCrashes() throws {
        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            try app.performAccessibilityAudit()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }
}
