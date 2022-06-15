//
//  SwipeActionsPluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 15.06.2022.
//

import XCTest

final class SwipeActionsPluginExampleUITest: BaseUITestCase {

    func testCollection_whenSwipeLeftFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Collection")
        tapTableElement("List Appearances with swipeable items")

        let cell = app.collectionViews.firstMatch.cells.firstMatch
        cell.swipeLeft()

        sleep(1)
        XCTAssertTrue(cell.buttons.count == 3)
    }

    func testTable_whenSwipeLeftFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Table")
        tapTableElement("Table with swipeable cells")

        let cell = app.tables.firstMatch.cells.firstMatch
        cell.swipeLeft()

        sleep(1)
        XCTAssertTrue(cell.buttons.count == 3)
    }

}
