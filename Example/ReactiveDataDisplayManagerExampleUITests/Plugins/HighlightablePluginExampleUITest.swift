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
        let expectation = XCTestExpectation(description: "Cell Pressed")
        let timeout: TimeInterval = 1
        var wasPresed = false

        setTab("Table")
        tapTableElement("Table with highlightable cells")

        let cell = getFirstCell(for: .table, id: "Higlighted_cells")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            wasPresed = cell.label == highlightedStyle
            expectation.fulfill()
        }
        cell.press(forDuration: 2)

        wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(wasPresed)
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
        let expectation = XCTestExpectation(description: "Cell Pressed")
        let timeout: TimeInterval = 1
        var wasPresed = false

        setTab("Collection")
        tapTableElement("Base collection view")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            wasPresed = cell.stringValue == highlightedStyle
            expectation.fulfill()
        }
        cell.press(forDuration: 2)

        wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(wasPresed)
        XCTAssertEqual(cell.stringValue, normalStyle)
    }

    func testCollection_whenCellTaped_thenTurnedSelectStyleAndDeselectStyle() throws {
        let selectedStyle = "Selected"
        let normalStyle = "Normal"

        setTab("Collection")
        tapTableElement("Base collection view")
        tapButton("Single mode")

        let cell = getFirstCell(for: .collection, id: "Collection_with_selectable_cells")

        cell.tap()
        XCTAssertEqual(cell.stringValue, selectedStyle)
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertEqual(cell.stringValue, normalStyle)
        XCTAssertFalse(cell.isSelected)
    }

}
