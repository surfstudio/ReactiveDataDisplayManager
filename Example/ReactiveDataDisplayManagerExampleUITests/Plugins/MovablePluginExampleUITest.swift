//
//  MovablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class MovablePluginExampleUITest: BaseUITestCase {

    private enum Constants {
        static let dragDuration: TimeInterval = 1
        static let waitTime: TimeInterval = 1.5 + dragDuration * 2
    }

    func testСollection_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let collectionId = "Collection_with_movable_cell"
        let sourceDraggable = "Cell 0"
        let destinationDraggable = "Cell 1"
        let duration = Constants.dragDuration

        setTab("Collection")
        tapTableElement("movable items")

        let sourceCell = getCell(for: .collection, collectionId: collectionId, cellId: sourceDraggable)
        let destinationCell = getCell(for: .collection, collectionId: collectionId, cellId: destinationDraggable)
        sourceCell.press(forDuration: duration, thenDragTo: destinationCell, withVelocity: .slow, thenHoldForDuration: duration)

        let firstCell = getFirstCell(for: .collection, id: collectionId)

        XCTAssertTrue(firstCell.waitForLabelEqualTo(destinationDraggable,
                                                    timeout: Constants.waitTime)
        )
    }

    func testTable_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let tableId = "Table_with_movable_cell"
        let sourceDraggable = "Cell: 1"
        let duration = Constants.dragDuration

        setTab("Table")
        tapTableElement("movable cell")

        let sourceCell = getCell(for: .table, collectionId: tableId, cellId: sourceDraggable)
        let destinationSection = app.tables[tableId].otherElements["Section 2"].firstMatch

        sourceCell
            .firstMatch
            .buttons
            .firstMatch
            .press(forDuration: duration,
                   thenDragTo: destinationSection,
                   withVelocity: .slow,
                   thenHoldForDuration: duration)

        let firstCell = getFirstCell(for: .table, id: tableId)

        XCTAssertTrue(firstCell.waitForLabelEqualTo("Cell: 2",
                                                    timeout: Constants.waitTime)
        )
    }

}
