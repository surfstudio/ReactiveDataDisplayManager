//
//  GravityFoldingHeaderGenerator.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Dryakhlykh on 11.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class GravityFoldingHeaderGenerator: GravityTableCellGenerator, FoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = true
    var childGenerators = [TableCellGenerator]()

    // MARK: - GravityTableCellGenerator

    var heaviness = 10

    func getHeaviness() -> Int {
        heaviness
    }

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

final class GravityCellGenerator: GravityTableCellGenerator {

    // MARK: - TableCellGenerator

    var heaviness = 11

    func getHeaviness() -> Int {
        heaviness
    }

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

final class GravityFoldingTableDataDisplayManagerTests: XCTestCase {

    // MARK: - Properties

    private var tableView: UITableView!
    private var ddm: GravityTableManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        ddm = tableView.rddm.gravityBuilder.build()
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

        let header = GravityFoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = true

        ddm.addCellGenerators([header, childGenerator1, childGenerator2, childGenerator3])

        // when

        (header as? SelectableItem)?.didSelectEvent.invoke(with: ())

        // then

        XCTAssert(ddm.generators[0][0] === header)
        XCTAssert(ddm.generators[0].count == 1)
    }

    func testUnfolding() {

        // given

        let childGenerator1 = GravityCellGenerator()
        let childGenerator2 = GravityCellGenerator()
        let childGenerator3 = GravityCellGenerator()

        let header = GravityFoldingHeaderGenerator()
        header.childGenerators = [childGenerator1, childGenerator2, childGenerator3]
        header.isExpanded = false

        ddm.addCellGenerator(header)

        // when

        (header as? SelectableItem)?.didSelectEvent.invoke(with: ())

        // then

        XCTAssert(ddm.generators[0][0] === header)
        XCTAssert(ddm.generators[0].count == 4)
    }
}
