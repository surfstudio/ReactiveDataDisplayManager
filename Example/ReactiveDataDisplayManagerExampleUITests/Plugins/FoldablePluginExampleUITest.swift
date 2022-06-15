//
//  FoldablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 15.06.2022.
//

import XCTest

final class FoldablePluginExampleUITest: BaseUITestCase {

    func testTable_whenFoldableCellTaped_thenShowSubcells_thenHideSubcells() throws {
        let tableId = "FoldableTableViewController"

        setTab("Table")
        tapTableElement("Table with foldable cell")

        let foldable = getCell(for: .table, collectionId: tableId, cellId: "Foldable cell1")
        foldable.tap()

        XCTAssertTrue(getCell(for: .table, collectionId: tableId, cellId: "First subcell").exists)
        XCTAssertTrue(getCell(for: .table, collectionId: tableId, cellId: "Second subcell").exists)

        foldable.tap()
        XCTAssertFalse(getCell(for: .table, collectionId: tableId, cellId: "First subcell").exists)
        XCTAssertFalse(getCell(for: .table, collectionId: tableId, cellId: "Second subcell").exists)
    }

    func testCollectionMultipleTap_whenCellTapped_thenCellSelected_thenCellDeselected() throws {
        setTab("Collection")
        tapTableElement("Foldable collection")

        let collection = app.collectionViews.firstMatch

        tapFirstCell(by: .collection)
        XCTAssertTrue(collection.cells.count > 1)

        tapFirstCell(by: .collection)
        XCTAssertFalse(collection.cells.count > 1)
    }

}
