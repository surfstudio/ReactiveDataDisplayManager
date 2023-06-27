//
//  DragAndDroppablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class DragAndDroppablePluginExampleUITest: BaseUITestCase {

    private enum Constants {
        static let dragDuration: TimeInterval = 1
        static let waitTime: TimeInterval = 2.5 * dragDuration
    }

    func testСollection_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let collectionId = "Collection_with_drag_n_drop_items"
        let sourceDraggable = "Cell: 1"
        let destinationDraggable = "Cell: 2"
        let duration = Constants.dragDuration

        setTab("Collection")
        tapTableElement("drag and drop item")

        let sourceCell = getCell(for: .collection, collectionId: collectionId, cellId: sourceDraggable)
        let destinationCell = getCell(for: .collection, collectionId: collectionId, cellId: destinationDraggable)
        sourceCell.press(forDuration: duration, thenDragTo: destinationCell, withVelocity: .fast, thenHoldForDuration: .zero)

        let firstCell = getFirstCell(for: .collection, id: collectionId)

        XCTAssertTrue(firstCell.waitForLabelEqualTo(destinationDraggable,
                                                    timeout: Constants.waitTime)
        )
    }

    func testTable_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let tableId = "Table_with_drag_n_drop_cell"
        let sourceDraggable = "Cell: 1"
        let destinationDraggable = "Cell: 2"
        let duration = Constants.dragDuration

        setTab("Table")
        tapTableElement("drag and drop cells")

        let sourceCell = getCell(for: .table, collectionId: tableId, cellId: sourceDraggable)
        let destinationCell = getCell(for: .table, collectionId: tableId, cellId: destinationDraggable)
        sourceCell.press(forDuration: duration, thenDragTo: destinationCell, withVelocity: .fast, thenHoldForDuration: .zero)

        let firstCell = getFirstCell(for: .table, id: tableId)

        XCTAssertTrue(firstCell.waitForLabelEqualTo(destinationDraggable,
                                                    timeout: Constants.waitTime)
        )
    }

}
