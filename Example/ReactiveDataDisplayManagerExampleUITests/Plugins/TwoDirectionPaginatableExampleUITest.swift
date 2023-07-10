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
        tapTableElement("Table with two direction pagination")

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

    func testTable_whenSwipeDown_thenPaginatorErrorAppear_thenHittableActivityIndicator() {
        let activityIndicator = app.activityIndicators["PaginatorView"].firstMatch
        let retryButton = app.buttons["Retry"].firstMatch

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
