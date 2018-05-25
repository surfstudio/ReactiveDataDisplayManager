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

    private var ddm: BaseTableDataDisplayManager!
    private var table: UITableViewSpy!

    override func setUp() {
        super.setUp()
        table = UITableViewSpy()
        ddm = BaseTableDataDisplayManager(collection: table)
    }
    
    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
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

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = HeaderGenerator()
        let gen = CellGenerator()
        let initialNumberOfSections = ddm.cellGenerators.count
        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)
        // then
        XCTAssert(initialNumberOfSections != ddm.cellGenerators.count)
    }

    func testThatAddCellGeneratorCallsRegisterNib() {
        // given
        let headerGen = HeaderGenerator()
        let gen = CellGenerator()
        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)
        // then
        XCTAssert(table.registerNibWasCalled)
    }

    func testThatAddCellGeneratorCallsFatalErrorIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = CellGenerator()
        expectFatalError(expectedMessage: "Section generators is empty. Firstly you should add a section header generator.") { // then
            self.ddm.addCellGenerator(gen) // when
        }
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen2)
        ddm.addCellGenerator(gen2)
        // then
        XCTAssert(ddm.cellGenerators.count == 2)
        XCTAssert(ddm.cellGenerators.first?.count == 3)
        XCTAssert(ddm.cellGenerators.last?.count == 2)
    }

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen3 = CellGenerator()
        let gen4 = CellGenerator()
        let gen5 = CellGenerator()
        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)

        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen5])
        ddm.addCellGenerator(gen4, after: gen3)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen1 && ddm.cellGenerators[0][1] === gen2)
        XCTAssert(ddm.cellGenerators[1][0] === gen3 && ddm.cellGenerators[1][1] === gen4 && ddm.cellGenerators[1][2] === gen5)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        self.ddm.addSectionHeaderGenerator(headerGen1)
        // when
        expectFatalError(expectedMessage: "Error adding cell generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        // when
        ddm.clearCellGenerators()
        // then
        XCTAssert(ddm.cellGenerators.isEmpty)
    }

    func testThatClearHeaderGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        // when
        ddm.clearHeaderGenerators()
        // then
        XCTAssert(ddm.sectionHeaderGenerators.isEmpty)
    }

    func testThatForceRefillReloadsCollection() {
        // given

        // when
        ddm.forceRefill()
        // then
        XCTAssert(table.reloadDataWasCalled)
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

    final class CellGenerator: TableCellGenerator {

        var identifier: UITableViewCell.Type {
            return UITableViewCell.self
        }

        func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

    }

    final class UITableViewSpy: UITableView {

        var reloadDataWasCalled: Bool = false
        var registerNibWasCalled: Bool = false

        override func reloadData() {
            super.reloadData()
            reloadDataWasCalled = true
        }

        override func registerNib(_ cellType: UITableViewCell.Type) {
            registerNibWasCalled = true
            // override not to call UI API
        }

    }

}
