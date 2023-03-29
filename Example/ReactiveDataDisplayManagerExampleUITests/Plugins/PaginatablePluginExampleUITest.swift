//
//  PaginatablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class PaginatablePluginExampleUITest: BaseUITestCase {

    private enum Constants {
        static let timeout: TimeInterval = 3
    }

    // Description: The first cell of the table is always the same
    func testTable_whenSwipeUp_thenCellsCountChanged() throws {
        let pageSize = 17

        setTab("Table")
        tapTableElement("Table with pagination")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))

        while table.cells.count <= pageSize {
            table.swipeUp()
        }

        XCTAssertGreaterThan(table.cells.count, pageSize)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUp_thenFirstVisibleCellChanged() throws {
        setTab("Collection")
        tapTableElement("Collection with pagination")

        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while collection.cells.firstMatch.label.contains("page 0") {
            collection.swipeUp()
        }

        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.label.contains("page 1"))
    }

    func testTable_whenSwipeUp_thenPaginatorErrorAppear_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]
        let retryButton = app.buttons["Retry"]

        setTab("Table")
        tapTableElement("Table with pagination")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))

        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeUp()
        }

        XCTAssertFalse(activityIndicator.isHittable)

        retryButton.tap()

        XCTAssertTrue(activityIndicator.isHittable)
    }

    func testCollection_whenSwipeUp_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]

        setTab("Collection")
        tapTableElement("Collection with pagination")

        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while !activityIndicator.isHittable {
            collection.swipeUp()
        }

        XCTAssertTrue(activityIndicator.isHittable)
    }

}
