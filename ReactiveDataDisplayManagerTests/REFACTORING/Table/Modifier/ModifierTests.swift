//
//  ModifierTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class ModifierTests: XCTestCase {

    private var ddm: BaseTableManager!
    private var table: UITableViewSpy!

    override func setUp() {
        super.setUp()
        table = UITableViewSpy()
        ddm = table.rddm.gravityBuilder
            .set(dataSource: { MockTableDataSource(manager: $0) })
            .build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
    }

}
