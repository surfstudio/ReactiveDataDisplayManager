//
//  SwipeActionsPluginExampleUITest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 15.06.2022.
//

import XCTest

final class SwipeActionsPluginExampleUITest: BaseUITestCase {

    func testCollection_whenSwipeLeftFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Collection")
        tapTableElement("List Appearances with swipeable items")

        let collectionView = app.collectionViews.firstMatch
        let cell = collectionView.firstMatch.cells.firstMatch

        cell.swipeLeft()
        XCTAssertTrue(collectionView.buttons["Flag"].exists)
        XCTAssertTrue(collectionView.buttons["More"].exists)
//        XCTAssertTrue(collectionView.buttons.count == 3)

        cell.swipeRight()
        XCTAssertFalse(collectionView.buttons["Flag"].exists)
        XCTAssertFalse(collectionView.buttons["More"].exists)
//        XCTAssertTrue(collectionView.buttons.count == 0)
    }

    func testCollection_whenSwipeRightFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Collection")
        tapTableElement("List Appearances with swipeable items")

        let collectionView = app.collectionViews.firstMatch
        let cell = collectionView.firstMatch.cells.firstMatch

        cell.swipeRight()
        XCTAssertTrue(collectionView.buttons["Delete"].exists)
        XCTAssertTrue(collectionView.buttons["Info"].exists)
        XCTAssertTrue(collectionView.buttons["Apply"].exists)
//        XCTAssertTrue(collectionView.buttons.count == 3)

        cell.swipeLeft()
        XCTAssertFalse(collectionView.buttons["Delete"].exists)
        XCTAssertFalse(collectionView.buttons["Info"].exists)
        XCTAssertFalse(collectionView.buttons["Apply"].exists)
//        XCTAssertTrue(collectionView.buttons.count == 0)
    }

    func testTable_whenSwipeLeftFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Table")
        tapTableElement("Table with swipeable cells")

        let cell = app.tables.firstMatch.cells.firstMatch

        cell.swipeLeft()
        XCTAssertTrue(cell.buttons["Flag"].exists)
        XCTAssertTrue(cell.buttons["More"].exists)
        XCTAssertTrue(cell.buttons.count == 3)

        cell.swipeRight()
        XCTAssertFalse(cell.buttons["Flag"].exists)
        XCTAssertFalse(cell.buttons["More"].exists)
        XCTAssertTrue(cell.buttons.count == 0)
    }

    func testTable_whenSwipeRightFirstCell_thenCellHaveThreeButtons() throws {
        setTab("Table")
        tapTableElement("Table with swipeable cells")

        let cell = app.tables.firstMatch.cells.firstMatch

        cell.swipeRight()
        XCTAssertTrue(cell.buttons["Delete"].exists)
        XCTAssertTrue(cell.buttons["Info"].exists)
        XCTAssertTrue(cell.buttons["Apply"].exists)
        XCTAssertTrue(cell.buttons.count == 3)

        cell.swipeLeft()
        XCTAssertFalse(cell.buttons["Delete"].exists)
        XCTAssertFalse(cell.buttons["Info"].exists)
        XCTAssertFalse(cell.buttons["Apply"].exists)
        XCTAssertTrue(cell.buttons.count == 0)
    }

}
