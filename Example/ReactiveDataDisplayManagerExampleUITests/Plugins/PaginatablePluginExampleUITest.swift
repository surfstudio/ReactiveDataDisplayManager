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
        let pageSize = 16

        setTab("Table")
        tapTableElement("pagination")

        let table = app.tables.firstMatch
        let retryButton = app.buttons["Retry"]

        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))
        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeUp(velocity: .fast)
        }

        retryButton.tap()

        while table.cells.count <= pageSize {
            table.swipeUp(velocity: .fast)
        }

        XCTAssertGreaterThan(table.cells.count, pageSize)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUp_thenFirstVisibleCellChanged() throws {
        setTab("Collection")
        tapTableElement("pagination")

        let collection = app.collectionViews.firstMatch
        let firstCell = app.collectionViews.cells.firstMatch
        let retryButton = app.buttons["Retry"]
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while !retryButton.isHittable {
            collection.swipeUp(velocity: .fast)
        }

        retryButton.tap()

        while firstCell.label.hasSuffix("page 0") {
            collection.swipeUp(velocity: .fast)
        }

        XCTAssertTrue(firstCell.label.hasSuffix("page 1"))
    }

    func testTable_whenSwipeUp_thenPaginatorErrorAppear_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]
        let retryButton = app.buttons["Retry"]

        setTab("Table")
        tapTableElement("pagination")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))

        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeUp(velocity: .fast)
        }

        XCTAssertFalse(activityIndicator.isHittable)

        retryButton.tap()

        XCTAssertTrue(activityIndicator.isHittable)
    }

    func testCollection_whenSwipeUp_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]
        let retryButton = app.buttons["Retry"]

        setTab("Collection")
        tapTableElement("pagination")

        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while !retryButton.isHittable {
            collection.swipeUp(velocity: .fast)
        }

        XCTAssertFalse(activityIndicator.isHittable)

        retryButton.tap()

        XCTAssertTrue(activityIndicator.isHittable)
    }

}
