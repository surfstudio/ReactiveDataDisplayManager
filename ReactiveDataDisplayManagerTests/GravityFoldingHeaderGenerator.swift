//
//  GravityFoldingHeaderGenerator.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Dryakhlykh on 11.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class GravityFoldingHeaderGenerator: GravityTableCellGenerator, GravityFoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = true
    var childGenerators = [GravityTableCellGenerator]()

    // MARK: - GravityTableCellGenerator

    var heaviness = 10

    var identifier: UITableViewCell.Type {
        return UITableViewCell.self
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(identifier)
    }
}

final class GravityCellGenerator: GravityTableCellGenerator {

    // MARK: - TableCellGenerator

    var heaviness = 11

    var identifier: UITableViewCell.Type {
        return UITableViewCell.self
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(identifier)
    }
}

final class GravityFoldingTableDataDisplayManagerTests: XCTestCase {

    // MARK: - Properties

    private var tableView: UITableView!
    private var ddm: GravityFoldingTableDataDisplayManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        ddm = GravityFoldingTableDataDisplayManager(collection: tableView)
    }

    override func tearDown() {
        super.tearDown()
        tableView = nil
        ddm = nil
    }

    // MARK: - Tests

    func testFolding() {

        // given

        let childGenerator1 = GravityCellGenerator()
        let childGenerator2 = GravityCellGenerator()
        let childGenerator3 = GravityCellGenerator()
        childGenerator2.heaviness = 12
        childGenerator3.heaviness = 13

        let header = GravityFoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = true

        ddm.addCellGenerators([header, childGenerator1, childGenerator2, childGenerator3])

        // when

        ddm.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then


        XCTAssert(ddm.cellGenerators[0][0] === header)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 0, section: 0)) != 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 1, section: 0)) == 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 2, section: 0)) == 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 3, section: 0)) == 0.0)
    }

    func testUnfolding() {

        // given

        let childGenerator1 = GravityCellGenerator()
        let childGenerator2 = GravityCellGenerator()
        let childGenerator3 = GravityCellGenerator()
        childGenerator2.heaviness = 12
        childGenerator3.heaviness = 13

        let header = GravityFoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = false

        ddm.addCellGenerators([header, childGenerator1, childGenerator2, childGenerator3])

        // when

        ddm.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then

        XCTAssert(ddm.cellGenerators[0][0] === header)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 0, section: 0)) != 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 1, section: 0)) != 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 2, section: 0)) != 0.0)
        XCTAssert(ddm.tableView(ddm.tableView ?? UITableView(), heightForRowAt: IndexPath(row: 3, section: 0)) != 0.0)
    }
}
