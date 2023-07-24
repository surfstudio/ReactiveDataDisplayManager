//
//  TwoDirectionPaginatableExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Антон Голубейков on 20.06.2023.
//

import XCTest

final class TwoDirectionPaginatableExampleUITest: BaseUITestCase {

    private enum Constants {
        static let timeout: TimeInterval = 3
    }

    // Description: The first cell of the table is always the same
    func testTable_whenSwipeUpAndDown_thenCellsCountChanged() throws {
        let threePagesSize = 120

        setTab("Table")
        tapTableElement("back/forward pagination")

        let table = app.tables.firstMatch
        let retryButton = app.buttons["Retry"].firstMatch

        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))
        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeDown(velocity: .fast)
        }

        retryButton.tap()

        while table.cells.count < threePagesSize {
            table.swipeUp(velocity: .fast)
        }

        XCTAssertGreaterThan(table.cells.count, threePagesSize)
    }

    // Description: In a collection, the first cell is the first visible cell
    func testCollection_whenSwipeUpAndDown_thenFirstVisibleCellChanged() throws {
        setTab("Collection")
        tapTableElement("back/forward pagination")

        let collection = app.collectionViews.firstMatch
        let firstCell = app.collectionViews.cells.firstMatch
        let retryButton = app.buttons["Retry"].firstMatch
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while !retryButton.isHittable {
            collection.swipeDown(velocity: .fast)
        }

        retryButton.tap()

        while firstCell.label.hasSuffix("page 0") {
            collection.swipeUp(velocity: .fast)
        }

    }

    func testTable_whenSwipeDown_thenPaginatorErrorAppear_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"].firstMatch
        let retryButton = app.buttons["Retry"].firstMatch

        setTab("Table")
        tapTableElement("back/forward pagination")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))

        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeDown(velocity: .fast)
        }

        XCTAssertFalse(activityIndicator.isHittable)

        retryButton.tap()

        XCTAssertTrue(activityIndicator.isHittable)
    }

    func testCollection_whenSwipeUp_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]
        let retryButton = app.buttons["Retry"]

        setTab("Collection")
        tapTableElement("back/forward pagination")

        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.waitForExistence(timeout: Constants.timeout))

        while !retryButton.isHittable {
            collection.swipeDown(velocity: .fast)
        }

        XCTAssertFalse(activityIndicator.isHittable)

        retryButton.tap()

        XCTAssertTrue(activityIndicator.isHittable)
    }

}
