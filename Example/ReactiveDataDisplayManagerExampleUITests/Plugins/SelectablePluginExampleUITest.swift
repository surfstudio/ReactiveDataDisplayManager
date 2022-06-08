//
//  SelectablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 08.06.2022.
//

import XCTest

final class SelectablePluginExampleUITest: XCTestCase {

    //swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
    }

    func testSelectablePluginNonAutoDeselected() throws {
        // Given
        let tab = app.tabBars.buttons["Table"]
        let table = app.tables.staticTexts["Table with selectable cells"]
        let switchButton = app.navigationBars["Table with selectable cells"].buttons["Single mode"]
        let deselectedCell = app.tables.staticTexts["Cell 1"]
        let selectedCell = app.tables.staticTexts["selected cell"]

        // When
        tab.tap()
        table.tap()
        switchButton.tap()

        // Then
        deselectedCell.tap()
        XCTAssertTrue(selectedCell.exists)

        selectedCell.tap()
        XCTAssertTrue(deselectedCell.exists)
    }

    func testSelectablePluginAutoDeselected() throws {
        // Given
        let tab = app.tabBars.buttons["Table"]
        let table = app.tables.staticTexts["Table with selectable cells"]
        let deselectedCell = app.tables.staticTexts["Cell 1"]
        let selectedCell = app.tables.staticTexts["selected cell"]

        // When
        tab.tap()
        table.tap()

        // Then
        deselectedCell.tap()
        XCTAssertTrue(selectedCell.exists)

        selectedCell.tap()
        XCTAssertFalse(deselectedCell.exists)
    }

    func testSelectablePluginNonAutoDeselectedCollection() throws {
        // Given
        let tab = app.tabBars.buttons["Collection"]
        let collection = app.tables.cells.staticTexts["Base collection view"]
        let deselectedCell = app.collectionViews.staticTexts["One"]
        let selectedCell = app.collectionViews.staticTexts["selected"]

        // When
        tab.tap()
        collection.tap()

        // Than
        deselectedCell.tap()
        XCTAssertTrue(selectedCell.exists)

        selectedCell.tap()
        XCTAssertTrue(deselectedCell.exists)
    }

}
