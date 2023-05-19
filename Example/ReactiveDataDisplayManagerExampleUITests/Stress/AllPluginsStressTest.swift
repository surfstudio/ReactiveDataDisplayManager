//
//  AllPluginsStressTest.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Никита Коробейников on 19.05.2023.
//

import XCTest
import UIKit

final class AllPluginsStressTest: BaseUITestCase {

    override func setUpWithError() throws {
        additionalCommands.append("-stress")
        try super.setUpWithError()
    }

    func testTable_whenAllPluginsScreenIsConstantlyUpdating_thenExpandableCellDidntCrashing() {

        setTab("Table")
        tapTableElement("Table with all plugins")

        let cell = getCell(for: .table, collectionId: "main_table", cellId: "expandable_cell")

        cell.tap(withNumberOfTaps: 10, numberOfTouches: 1)
    }

}
