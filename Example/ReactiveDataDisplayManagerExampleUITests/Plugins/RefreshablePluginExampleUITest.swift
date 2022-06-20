//
//  RefreshablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by porohov on 20.06.2022.
//

import XCTest
import UIKit

final class RefreshablePluginExampleUITest: BaseUITestCase {

    func testTable_whenScrollDown_thenShowRefreshControl() throws {
        setTab("Table")
        tapTableElement("Table with refresh control")

        let table = app.tables["Table_with_refresh_control"]
        let cell = getFirstCell(for: .table, id: "Table_with_refresh_control")
        let refreshControl = app.otherElements["RefreshableTableViewController_RefreshControl"]

        let dragBegin = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0))
        let dragEnd = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        dragBegin.press(forDuration: 0.1, thenDragTo: dragEnd)

        XCTAssertTrue(refreshControl.exists)
        XCTAssertTrue(cell.label == "Cell 1")

        sleep(3)
        XCTAssertFalse(refreshControl.exists)
        XCTAssertTrue(cell.label == "Refreshing 1")
    }

    func testCollection_whenScrollDown_thenShowRefreshControl() throws {
        setTab("Collection")
        tapTableElement("List Appearances with swipeable items")

        let collection = app.collectionViews["List_Appearances_with_swipeable_items"]
        let cell = getFirstCell(for: .collection, id: "List_Appearances_with_swipeable_items")
        let refreshControl = app.otherElements["SwipeableCollectionListViewController_RefreshControl"]

        let dragBegin = collection.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0))
        let dragEnd = collection.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        dragBegin.press(forDuration: 0.1, thenDragTo: dragEnd)

        XCTAssertTrue(refreshControl.exists)
        XCTAssertTrue(cell.label == "Item 1")

        sleep(3)
        XCTAssertFalse(refreshControl.exists)
        XCTAssertTrue(cell.label == "Refreshing 1")
    }

}
