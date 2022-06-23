//
//  HighlightablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by porohov on 17.06.2022.
//

import XCTest

final class HighlightablePluginExampleUITest: BaseUITestCase {

    func testTable_whenCellTaped_thenCellhighlighted() throws {
        let normalStyle = "Normal"
        let highlightedStyle = "Highlighted"

        setTab("Table")
        tapTableElement("Table with highlightable cells")

        let cell = getFirstCell(for: .table, id: "Higlighted_cells")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(cell.label, highlightedStyle)
        }
        cell.press(forDuration: 2)

        XCTAssertEqual(cell.label, normalStyle)
    }

    func testTable_whenCellTaped_thenTurnedSelectStyleAndDeselectStyle() throws {
        let selectedStyle = "Selected"
        let normalStyle = "Normal"

        setTab("Table")
        tapTableElement("Table with highlightable cells")
        tapButton("Single mode")

        let cell = getFirstCell(for: .table, id: "Higlighted_cells")

        cell.tap()
        XCTAssertEqual(cell.label, selectedStyle)
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertEqual(cell.label, normalStyle)
        XCTAssertFalse(cell.isSelected)
    }

    func testCollection_whenCellTaped_thenCellhighlighted() throws {
        let normalStyle = "Normal"
        let highlightedStyle = "Highlighted"

        setTab("Collection")
        tapTableElement("Base collection view")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(cell.label, highlightedStyle)
        }
        cell.press(forDuration: 2)

        XCTAssertEqual(cell.label, normalStyle)
    }

    func testCollection_whenCellTaped_thenTurnedSelectStyleAndDeselectStyle() throws {
        let selectedStyle = "Selected"
        let normalStyle = "Normal"

        setTab("Collection")
        tapTableElement("Base collection view")
        tapButton("Single mode")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        cell.tap()
        XCTAssertEqual(cell.label, selectedStyle)
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertEqual(cell.label, normalStyle)
        XCTAssertFalse(cell.isSelected)
    }

}
