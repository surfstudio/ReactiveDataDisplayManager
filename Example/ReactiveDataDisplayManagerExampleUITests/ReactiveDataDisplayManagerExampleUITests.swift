//
//  ReactiveDataDisplayManagerExampleUITests.swift
//  
//
//  Created by Artem Kayumov on 19.05.2022./
//

import XCTest

class ReactiveDataDisplayManagerExampleUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
    }

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

    func setTab(_ screenName: String) {
        app.tabBars.buttons[screenName].tap()
    }

    func assertAllScreensOpeningWithoutCrashes() {
        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }
}
