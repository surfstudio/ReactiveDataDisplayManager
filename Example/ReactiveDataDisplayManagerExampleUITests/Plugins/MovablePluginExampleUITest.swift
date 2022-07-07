//
//  MovablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

final class MovablePluginExampleUITest: BaseUITestCase {

    private enum Constants {
        static let dragDuration = 0.5
        static let waitTime: UInt32 = 1
    }

    func testСollection_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let collectionId = "Collection_with_movable_cell"
        let sourceDraggable = "Cell 0"
        let destinationDraggable = "Cell 1"
        let duration = Constants.dragDuration

        setTab("Collection")
        tapTableElement("Collection with movable items")

        let sourceCell = getCell(for: .collection, collectionId: collectionId, cellId: sourceDraggable)
        let destinationCell = getCell(for: .collection, collectionId: collectionId, cellId: destinationDraggable)
        sourceCell.press(forDuration: duration, thenDragTo: destinationCell, withVelocity: .slow, thenHoldForDuration: duration)

        sleep(Constants.waitTime)
        let firstCell = getFirstCell(for: .collection, id: collectionId)

        XCTAssertTrue(firstCell.label == destinationDraggable)
    }

    func testTable_whenFirstCellDragingToDestination_thenDestinationCellBecomesFirst() throws {
        let tableId = "Table_with_movable_cell"
        let sourceDraggable = "Cell: 1"
        let duration = Constants.dragDuration

        setTab("Table")
        tapTableElement("Table with movable cell")

        let sourceCell = getCell(for: .table, collectionId: tableId, cellId: sourceDraggable)
        let destinationSection = app.tables[tableId].otherElements["Section 2"]

        sourceCell.buttons.firstMatch
            .press(forDuration: duration, thenDragTo: destinationSection, withVelocity: .slow, thenHoldForDuration: duration)

        sleep(Constants.waitTime)
        let firstCell = getFirstCell(for: .table, id: tableId)

        XCTAssertTrue(firstCell.label == "Cell: 2")
    }

}
