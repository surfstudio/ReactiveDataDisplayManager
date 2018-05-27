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

    func testThatAddCellGeneratorToHeaderAddsGeneratorsToCorrectHeader() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        // when
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen2)
        // then
        XCTAssert(ddm.cellGenerators.first?.count == 3)
        XCTAssert(ddm.cellGenerators.last?.count == 1)
    }

    // MARK: - Table actions tests

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen3 = CellGenerator()
        let gen4 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        // when
        ddm.remove(gen3, needRemoveEmptySection: true)
        ddm.remove(gen4, needRemoveEmptySection: true)
        // then
        XCTAssert(ddm.sectionHeaderGenerators.count == 1)
        XCTAssert(ddm.cellGenerators.count == 1)
    }

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen3 = CellGenerator()
        let gen4 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        // when
        ddm.remove(gen3, needScrollAt: .top)
        // then
        XCTAssert(table.scrollToRowWasCalled == true)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen3 = CellGenerator()
        let gen4 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        // when
        ddm.remove(gen1)
        // then
        XCTAssert(ddm.cellGenerators.first?.first === gen2)
        XCTAssert(ddm.cellGenerators.first?.count == 1)
    }

    func testThatInsertGeneratorAfterGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let gen3 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen4 = CellGenerator()
        let gen5 = CellGenerator()
        let gen6 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen4, gen6], toHeader: headerGen2)
        // when
        ddm.insert(after: gen1, new: gen2)
        ddm.insert(after: gen4, new: gen5)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen1 && ddm.cellGenerators[0][1] === gen2 && ddm.cellGenerators[0][2] === gen3)
        XCTAssert(ddm.cellGenerators[1][0] === gen4 && ddm.cellGenerators[1][1] === gen5 && ddm.cellGenerators[1][2] === gen6)
    }

    func testThatInsertGeneratorBeforeGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let gen3 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen4 = CellGenerator()
        let gen5 = CellGenerator()
        let gen6 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)
        // when
        ddm.insert(before: gen2, new: gen1)
        ddm.insert(before: gen5, new: gen4)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen1 && ddm.cellGenerators[0][1] === gen2 && ddm.cellGenerators[0][2] === gen3)
        XCTAssert(ddm.cellGenerators[1][0] === gen4 && ddm.cellGenerators[1][1] === gen5 && ddm.cellGenerators[1][2] === gen6)
    }

    func testThatInsertGeneratorToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let gen3 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen4 = CellGenerator()
        let gen5 = CellGenerator()
        let gen6 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)
        // when
        ddm.insert(to: headerGen1, new: gen1)
        ddm.insert(to: headerGen2, new: gen4)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen1 && ddm.cellGenerators[0][1] === gen2 && ddm.cellGenerators[0][2] === gen3)
        XCTAssert(ddm.cellGenerators[1][0] === gen4 && ddm.cellGenerators[1][1] === gen5 && ddm.cellGenerators[1][2] === gen6)
    }

    func testThatReplaceOldGeneratorOnNewReplacesGeneratorCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let gen3 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        // when
        ddm.replace(oldGenerator: gen1, on: gen3)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen3 && ddm.cellGenerators[0][1] === gen2)
    }

    func testThatSwapGeneratorWithGeneratorSwapsCorrectly() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen2 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)
        // when
        ddm.swap(generator: gen1, with: gen2)
        // then
        XCTAssert(ddm.cellGenerators[0][0] === gen2 && ddm.cellGenerators[1][0] === gen1)
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
        var scrollToRowWasCalled: Bool = false

        override func reloadData() {
            super.reloadData()
            reloadDataWasCalled = true
        }

        override func registerNib(_ cellType: UITableViewCell.Type) {
            registerNibWasCalled = true
            // don't call super for not calling UI API
        }

        override func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool) {
            scrollToRowWasCalled = true
        }

    }

}
