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
        let pageSize = 40

        setTab("Table")
        tapTableElement("Table with two direction pagination")

        let table = app.tables.firstMatch
        let retryButton = app.buttons["Retry"]

        XCTAssertTrue(table.waitForExistence(timeout: Constants.timeout))
        XCTAssertTrue(retryButton.waitForExistence(timeout: Constants.timeout * 2))

        while !retryButton.isHittable {
            table.swipeUp(velocity: .fast)
        }

        retryButton.tap()

        while table.cells.count <= pageSize {
            table.swipeDown(velocity: .fast)
        }

        XCTAssertGreaterThan(table.cells.count, pageSize)
    }

    func testTable_whenSwipeDown_thenPaginatorErrorAppear_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"]
        let retryButton = app.buttons["Retry"]

        setTab("Table")
        tapTableElement("Table with two direction pagination")

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

}

