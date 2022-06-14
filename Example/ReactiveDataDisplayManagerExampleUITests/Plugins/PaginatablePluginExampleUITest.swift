//
//  PaginatablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class PaginatablePluginExampleUITest: XCTestCase {

    //swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
    }

    // Description: The first cell of the table is always the same
    func testTable_whenSwipeUp_thenCellCountChanged() throws {
        setTab("Table")
        tapTableElement("Table with pagination")

        sleep(3)
        let table = app.tables.firstMatch
        let maxIteration = 10
        var iterations = 0

        while table.cells.count < 18 && iterations < maxIteration {
            table.swipeUp()
            iterations += 1
        }

        let cell = table.cells["page 1"]
        XCTAssertTrue(cell.exists)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUp_thenPageChanged() throws {
        setTab("Collection")
        tapTableElement("Collection with pagination")

        sleep(3)
        let collection = app.collectionViews.firstMatch
        let maxIteration = 10
        var iterations = 0

        while collection.cells.firstMatch.label.contains("page 0") && iterations < maxIteration {
            collection.swipeUp()
            iterations += 1
        }

        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.label.contains("page 1"))
    }

}

private extension PaginatablePluginExampleUITest {

    func setTab(_ screenName: String) {
        app.tabBars.buttons[screenName].tap()
    }

    func tapTableElement(_ screenName: String) {
        app.tables.staticTexts[screenName].tap()
    }

}
