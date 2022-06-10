//
//  SelectablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 08.06.2022.
//

import XCTest

final class SelectablePluginExampleUITest: XCTestCase {

    //swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
    }

    func testTableMultipleTap_whenCellTaped_thenCellSelected_thenCellDeselected() throws {
        setTab("Table")
        tapTableElement("Table with selectable cells")
        tapButton("Single mode")

        let cell = getFirstCell(for: .table, id: "Table_with_selectable_cells")

        cell.tap()
        XCTAssertTrue(cell.isSelected)

        cell.tap()
        XCTAssertFalse(cell.isSelected)
    }

    func testTableSingleTap_whenCellTaped_thenCellNotSelected() throws {
        setTab("Table")
        tapTableElement("Table with selectable cells")

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

private extension SelectablePluginExampleUITest {

    enum CollectionType {
        case table, collection
    }

    func setTab(_ screenName: String) {
        app.tabBars.buttons[screenName].tap()
    }

    func tapTableElement(_ screenName: String) {
        app.tables.staticTexts[screenName].tap()
    }

    func tapButton(_ screenName: String) {
        app.buttons[screenName].tap()
    }

    func getFirstCell(for collection: CollectionType, id: String) -> XCUIElement {
        let collection = (collection == .collection ? app.collectionViews : app.tables)
            .matching(identifier: id)
        return collection.cells.firstMatch
    }

}
