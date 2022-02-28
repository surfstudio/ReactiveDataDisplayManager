//
//  BaseTableDataDisplayManagerTests.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 22/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

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

    func testThatCustomOperationAddCellGeneratorCallsRegisterNib() {
        // Arrange
        let headerGen = HeaderGenerator()
        let gen = CellGenerator()
        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += gen
        // Assert
        XCTAssert(table.registerNibWasCalled)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let headerGen = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += [gen1, gen2]
        // Assert
        XCTAssert(table.registerNibWasCalled)
        XCTAssert(ddm.cellGenerators[0].count == 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = CellGenerator()
        // when
        ddm.addCellGenerator(gen)
        // then
        XCTAssert(ddm.sectionHeaderGenerators.count == 1)
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

    func testThatUpdateGeneratorsUpdatesNeededGenerators() {
        // given
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let gen2 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen3 = CellGenerator()
        let gen4 = CellGenerator()
        let gen5 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2])
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4, gen5])
        // when
        ddm.update(generators: [gen1, gen4])
        // then
        XCTAssert(table.lastReloadedRows == [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 1)])
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

    func testThatReloadSectionCallTableViewMethod() {
        // Arrange
        let headerGenerator = HeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)
        // Act
        ddm.reloadSection(by: headerGenerator)
        // Assert
        XCTAssert(table.sectionWasReloaded)
    }

    func testThatReloadSectionWithInvalidHeaderGeneratorNotCallTableViewMethod() {
        // Arrange
        let headerGenerator = HeaderGenerator()
        let wrongHeaderGenerator = HeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)
        // Act
        ddm.reloadSection(by: wrongHeaderGenerator)
        // Assert
        XCTAssertFalse(table.sectionWasReloaded)
    }

    func testThatRemoveAllGeneratorsClearsSection() {
        // Arrange
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        let gen2 = CellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)
        // Act
        ddm.removeAllGenerators(from: headerGen2)
        // Assert
        XCTAssert(table.numberOfSections == 2)
        XCTAssert(table.numberOfRows(inSection: 0) == 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
        XCTAssert(table.numberOfRows(inSection: 1) == 0, "Expected 0, got \(table.numberOfRows(inSection: 1))")
    }

    func testThatRemoveAllGeneratorsDoesntClearInvalidSection() {
        // Arrange
        let headerGen1 = HeaderGenerator()
        let gen1 = CellGenerator()
        let headerGen2 = HeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        // Act
        ddm.removeAllGenerators(from: headerGen2)
        // Assert
        XCTAssert(table.numberOfSections == 1)
        XCTAssert(table.numberOfRows(inSection: 0) == 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
    }

    func testThatMovableGeneratorIsntMoveToAnotherSection() {
        // Arrange
        let gen1 = NotMovableToAnotherSectionGenerator()
        let gen2 = NotMovableToAnotherSectionGenerator()
        ddm.addSectionHeaderGenerator(EmptyTableHeaderGenerator())
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(EmptyTableHeaderGenerator())
        ddm.addCellGenerator(gen2)
        // Act
        ddm.tableView(table, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
        // Assert
        XCTAssert(table.numberOfRows(inSection: 0) == 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
        XCTAssert(table.numberOfRows(inSection: 1) == 1, "Expected 1, got \(table.numberOfRows(inSection: 1))")
    }

    func testThatMovableGeneratorMoveToAnotherSection() {
        // Arrange
        let gen1 = MovableToAnotherSectionGenerator()
        let gen2 = MovableToAnotherSectionGenerator()
        ddm.addSectionHeaderGenerator(EmptyTableHeaderGenerator())
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(EmptyTableHeaderGenerator())
        ddm.addCellGenerator(gen2)
        // Act
        ddm.tableView(table, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
        // Assert
        XCTAssert(table.numberOfRows(inSection: 0) == 0, "Expected 0, got \(table.numberOfRows(inSection: 0))")
        XCTAssert(table.numberOfRows(inSection: 1) == 2, "Expected 2, got \(table.numberOfRows(inSection: 1))")
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

    class CellGenerator: TableCellGenerator {

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

    final class MovableToAnotherSectionGenerator: CellGenerator, MovableGenerator { }

    final class NotMovableToAnotherSectionGenerator: CellGenerator, MovableGenerator {
        func canMoveInOtherSection() -> Bool {
            return false
        }
    }

    final class UITableViewSpy: UITableView {

        var reloadDataWasCalled = false
        var registerNibWasCalled = false
        var scrollToRowWasCalled = false
        var lastReloadedRows: [IndexPath] = []
        var sectionWasReloaded = false

        override func reloadData() {
            super.reloadData()
            reloadDataWasCalled = true
        }

        override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
            registerNibWasCalled = true
            // don't call super to avoid UI API call
        }

        override func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
            scrollToRowWasCalled = true
        }

        override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
            lastReloadedRows = indexPaths
        }

        override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
            sectionWasReloaded = true
        }

        override func beginUpdates() {
            // don't call super to avoid UI API call
        }

        override func endUpdates() {
            // don't call super to avoid UI API call
        }

    }

}
