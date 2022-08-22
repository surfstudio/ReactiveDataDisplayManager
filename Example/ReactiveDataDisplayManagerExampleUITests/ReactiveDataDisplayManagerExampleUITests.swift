//
//  ReactiveDataDisplayManagerExampleUITests.swift
//  
//
//  Created by Artem Kayumov on 19.05.2022./
//

import XCTest

class ReactiveDataDisplayManagerExampleUITests: BaseUITestCase {

    func testCollectionScreen() throws {
        setTab("Collection")
        assertAllScreensOpeningWithoutCrashes()
    }

    func testTableScreen() throws {
        setTab("Table")
        assertAllScreensOpeningWithoutCrashes()
    }

    func testStackScreen() throws {
        setTab("Stack")
        assertAllScreensOpeningWithoutCrashes()
    }
}

// MARK: - Private methods

private extension ReactiveDataDisplayManagerExampleUITests {

    func assertAllScreensOpeningWithoutCrashes() {
        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }
}
