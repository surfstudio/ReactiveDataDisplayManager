//
//  FoldingTableDataDisplayManagerTests.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Dryakhlykh on 11.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class FoldingHeaderGenerator: TableCellGenerator, FoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = true
    var childGenerators = [TableCellGenerator]()

    // MARK: - TableCellGenerator

    var identifier: String {
        return String(describing: UITableViewCell.self)
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(identifier)
    }
}

final class CellGenerator: TableCellGenerator {

    // MARK: - TableCellGenerator

    var identifier: String {
        return String(describing: UITableViewCell.self)
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(identifier)
    }
}

final class FoldingTableDataDisplayManagerTests: XCTestCase {

    // MARK: - Properties

    private var tableView: UITableView!
    private var ddm: FoldingTableDataDisplayManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        ddm = FoldingTableDataDisplayManager(collection: tableView)
    }

    override func tearDown() {
        super.tearDown()
        tableView = nil
        ddm = nil
    }

    // MARK: - Tests

    func testFolding() {

        // given

        let childGenerator1 = CellGenerator()
        let childGenerator2 = CellGenerator()
        let childGenerator3 = CellGenerator()

        let header = FoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = true

        ddm.addCellGenerators([header, childGenerator1, childGenerator2, childGenerator3])

        // when

        ddm.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then

        XCTAssertIdentical(ddm.cellGenerators[0][0], header)
        XCTAssertEqual(ddm.cellGenerators[0].count, 1)
    }

    func testUnfolding() {

        // given

        let childGenerator1 = CellGenerator()
        let childGenerator2 = CellGenerator()
        let childGenerator3 = CellGenerator()

        let header = FoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = false

        ddm.addCellGenerator(header)

        // when

        ddm.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then

        XCTAssertIdentical(ddm.cellGenerators[0][0], header)
        XCTAssertEqual(ddm.cellGenerators[0].count, 4)
    }
}
