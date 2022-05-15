//
//  ReactiveDataDisplayManagerExampleUITests.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Artem Kayumov on 11.05.2022.
//

import XCTest

class ReactiveDataDisplayManagerExampleUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCollectionScreen() throws {
        testTable("Collection")
    }

    func testTableScreen() throws {
        testTable("Table")
    }

    func testStackScreen() throws {
        testTable("Stack")
    }
}

// MARK: - Private methods

private extension ReactiveDataDisplayManagerExampleUITests {

    func testTable(_ screenName: String) {
        app.tabBars.buttons[screenName].tap()
        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }
}
