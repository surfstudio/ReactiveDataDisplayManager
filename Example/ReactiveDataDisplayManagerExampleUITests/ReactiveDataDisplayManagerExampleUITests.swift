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

        app.tabBars.buttons["Collection"].tap()

        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }

    func testTableScreen() throws {

        app.tabBars.buttons["Table"].tap()

        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }

    func testStackScreen() throws {

        app.tabBars.buttons["Stack"].tap()

        let tablesQuery = app.tables
        for i in 0...tablesQuery.cells.count - 1 {
            print("===== cell number: \(i) =====")
            tablesQuery.cells.element(boundBy: i).tap()
            app.navigationBars.firstMatch.buttons["Back"].tap()
        }
    }
}
