//
//  BaseTableDataDisplayManagerTests.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 22/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseTableDataDisplayManagerTests: XCTestCase {

    private lazy var ddm = BaseTableDataDisplayManager(collection: UITableView())

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Initialization tests

    func testThatObjectPropertiesInitializeCorrectly() {
        // given
        let table = UITableView()
        // when
        let ddm = BaseTableDataDisplayManager(collection: table)
        // then
        XCTAssert(ddm.cellGenerators.isEmpty)
        XCTAssert(ddm.sectionHeaderGenerators.isEmpty)
    }

    // MARK: - Generator actions tests

    func testThatAddSectionGeneratorWorksCorrectly() {
        // given
        let gen1 = HeaderGenerator()
        let gen2 = HeaderGenerator()
        // when
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen2)
        // then
        XCTAssert(ddm.sectionHeaderGenerators.count == 3)
    }

    // MARK: - Mocks

    final class HeaderGenerator: TableHeaderGenerator {

        override func generate() -> UIView {
            return UIView()
        }

        override func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
            return 1
        }

    }

}
