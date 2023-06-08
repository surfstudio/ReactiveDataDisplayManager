//
//  SelectablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 08.06.2022.
//

import XCTest

final class SelectablePluginExampleUITest: BaseUITestCase {

    func testTableMultipleTap_whenCellTaped_thenCellSelected_thenCellDeselected() throws {
        setTab("Table")
        tapTableElement("selectable cells")
        tapButton("Single mode")

        let cell = getFirstCell(for: .table, id: "Table_with_selectable_cells")

        cell.tap()
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertFalse(cell.isSelected)
    }

    func testTableSingleTap_whenCellTaped_thenCellNotSelected() throws {
        setTab("Table")
        tapTableElement("selectable cells")

        let cell = getFirstCell(for: .table, id: "Table_with_selectable_cells")

        for _ in 0...3 {
            cell.tap()
            XCTAssertFalse(cell.isSelected)
        }
    }

    func testCollectionMultipleTap_whenCellTapped_thenCellSelected_thenCellDeselected() throws {
        setTab("Collection")
        tapTableElement("Base collection view")
        tapButton("Single mode")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        cell.tap()
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertFalse(cell.isSelected)
    }

    func testCollectionSingleTap_whenCellTapped_thenCellNotSelected() throws {
        setTab("Collection")
        tapTableElement("Base collection view")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        for _ in 0...3 {
            cell.tap()
            XCTAssertFalse(cell.isSelected)
        }
    }

}
