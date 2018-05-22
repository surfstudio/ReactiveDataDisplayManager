//
//  BaseTableDataDisplayManagerTests.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 22/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

class BaseTableDataDisplayManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatObjectPropertiesInitializeCorrectly() {
        // given
        let table = UITableView()
        // when
        let object = BaseTableDataDisplayManager(estimatedHeight: 1, collection: table)
        // then
        XCTAssert(object.cellGenerators.isEmpty)
        XCTAssert(object.sectionHeaderGenerator.isEmpty)
    }

}
