//
//  RefreshablePluginExampleUITest.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by porohov on 20.06.2022.
//

import XCTest

final class RefreshablePluginExampleUITest: BaseUITestCase {

    func testTableMultipleTap_whenCellTaped_thenCellSelected_thenCellDeselected() throws {
        setTab("Table")
        tapTableElement("Table with refresh control")

        let table = app.tables["Table_with_refresh_control"]
        

        sleep(3)
    }

}
