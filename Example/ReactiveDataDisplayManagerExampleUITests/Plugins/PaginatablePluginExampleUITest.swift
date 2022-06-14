//
//  PaginatablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class PaginatablePluginExampleUITest: BaseUITestCase {

    // Description: The first cell of the table is always the same
    func testTable_whenSwipeUp_thenCellsCountChanged() throws {
        let itemsInOnePage = 17
        let maxIteration = 10
        var iterations = 0

        setTab("Table")
        tapTableElement("Table with pagination")

        sleep(3)
        let table = app.tables.firstMatch

        while table.cells.count <= itemsInOnePage && iterations < maxIteration {
            table.swipeUp()
            iterations += 1
        }

        let currentPage = table.cells.count / itemsInOnePage
        XCTAssertTrue(currentPage == 2)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUp_thenFirstVisibleCellChanged() throws {
        let maxIteration = 10
        var iterations = 0

        setTab("Collection")
        tapTableElement("Collection with pagination")

        sleep(3)
        let collection = app.collectionViews.firstMatch

        while collection.cells.firstMatch.label.contains("page 0") && iterations < maxIteration {
            collection.swipeUp()
            iterations += 1
        }

        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.label.contains("page 1"))
    }

}
