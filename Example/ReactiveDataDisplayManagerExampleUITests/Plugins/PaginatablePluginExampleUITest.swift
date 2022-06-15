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

        setTab("Table")
        tapTableElement("Table with pagination")

        sleep(3)
        let table = app.tables.firstMatch

        while table.cells.count <= itemsInOnePage {
            table.swipeUp()
        }

        let currentPage = table.cells.count / itemsInOnePage
        XCTAssertTrue(currentPage == 2)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUp_thenFirstVisibleCellChanged() throws {
        setTab("Collection")
        tapTableElement("Collection with pagination")

        sleep(3)
        let collection = app.collectionViews.firstMatch

        while collection.cells.firstMatch.label.contains("page 0") {
            collection.swipeUp()
        }

        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.label.contains("page 1"))
    }

    func testTable_whenSwipeUp_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]

        setTab("Table")
        tapTableElement("Table with pagination")

        sleep(4)
        let table = app.tables.firstMatch

        while !activityIndicator.isHittable {
            table.swipeUp()
        }

        XCTAssertTrue(activityIndicator.isHittable)
    }

    func testCollection_whenSwipeUp_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]

        setTab("Collection")
        tapTableElement("Collection with pagination")

        sleep(4)
        let collection = app.collectionViews.firstMatch

        while !activityIndicator.isHittable {
            collection.swipeUp()
        }

        XCTAssertTrue(activityIndicator.isHittable)
    }

}
