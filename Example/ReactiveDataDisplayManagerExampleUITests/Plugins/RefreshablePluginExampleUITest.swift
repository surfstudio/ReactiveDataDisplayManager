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
        tapTableElement("Collection list with refreshing")

        let collection = app.collectionViews["Refrashable_collection_list"]
        let cell = getFirstCell(for: .collection, id: "Refrashable_collection_list")
        let refreshControl = app.otherElements["RefreshableCollectionViewController_RefreshControl"]

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
