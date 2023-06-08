//
//  RefreshablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by porohov on 20.06.2022.
//

import XCTest
import UIKit

final class RefreshablePluginExampleUITest: BaseUITestCase {

    private enum Constants {
        static let dragDuration: TimeInterval = 0.5
        static let timeout: TimeInterval = 3
    }

    func testTable_whenScrollDown_thenShowRefreshControl() throws {
        setTab("Table")
        tapTableElement("refresh control")

        let cell = getFirstCell(for: .table, id: "Table_with_refresh_control")
        let refreshControl = app.otherElements["RefreshableTableViewController_RefreshControl"]

        let start = cell.coordinate(withNormalizedOffset: .zero)
        let end = cell.coordinate(withNormalizedOffset: .init(dx: 0, dy: 6))

        start.press(forDuration: Constants.dragDuration,
                    thenDragTo: end)

        XCTAssertTrue(refreshControl.waitForExistence(timeout: Constants.timeout))
        XCTAssertTrue(cell.label == "Cell 1")

        XCTAssertTrue(refreshControl.waitForNonExistence(timeout: Constants.timeout))
        XCTAssertTrue(cell.label == "Refreshing 1")
    }

    func testCollection_whenScrollDown_thenShowRefreshControl() throws {
        setTab("Collection")
        tapTableElement("Collection list with refreshing")

        let cell = getFirstCell(for: .collection, id: "Refrashable_collection_list")
        let refreshControl = app.otherElements["RefreshableCollectionViewController_RefreshControl"]

        let start = cell.coordinate(withNormalizedOffset: .init(dx: 10, dy: 10))
        let end = cell.coordinate(withNormalizedOffset: .init(dx: 10, dy: 20))

        start.press(forDuration: Constants.dragDuration,
                    thenDragTo: end)

        XCTAssertTrue(refreshControl.waitForExistence(timeout: Constants.timeout))
        XCTAssertTrue(cell.label == "Item 1")

        XCTAssertTrue(refreshControl.waitForNonExistence(timeout: Constants.timeout))
        XCTAssertTrue(cell.label == "Refreshing 1")
    }

}
