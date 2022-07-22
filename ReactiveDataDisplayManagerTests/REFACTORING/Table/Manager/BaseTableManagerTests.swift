// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseTableManagerTests: XCTestCase {

    private var ddm: BaseTableManager!
    private var table: SpyUITableView!

    override func setUp() {
        super.setUp()
        table = SpyUITableView()
        ddm = table.rddm.baseBuilder.build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
    }

    // MARK: - Initialization tests

    func testThatObjectPropertiesInitializeCorrectly() {
        // when
        let ddm = BaseTableManager()
        // then
        XCTAssertTrue(ddm.generators.isEmpty)
        XCTAssertTrue(ddm.sections.isEmpty)
        XCTAssertNil(ddm.delegate)
        XCTAssertNil(ddm.dataSource)
        XCTAssertNil(ddm.view)
    }

    // MARK: - Generator actions tests

    func testThatForceRefillReloadsCollection() {
        // when
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.reloadDataWasCalled)
    }

    func testThatAddCellGeneratorCallsRegisterNib() {
        // given
        let gen = StubTableCellGenerator()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertTrue(table.registerNibWasCalled)
        XCTAssertEqual(ddm.generators.first?.count, 1)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        // Act
        ddm += [gen1, gen2]

        // Assert
        XCTAssertTrue(table.registerNibWasCalled)
        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.generators.first?.count, 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = StubTableCellGenerator()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.generators.first?.count, 1)
    }

    func testThatAddCellGeneratorAfterGenerator() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)

        // when
        XCTAssertEqual(ddm.generators.first?.count, 2)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        // when
        expectFatalError(expectedMessage: "Error adding TableCellGenerator generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // Then
        }
    }

    func testThatUpdateGeneratorsUpdatesNeededGenerators() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4, gen5])

        // when
        ddm.update(generators: [gen1, gen4])

        // then
        XCTAssertEqual(table.lastReloadedRows, [IndexPath(row: 0, section: 0), IndexPath(row: 3, section: 0)])
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        ddm.addCellGenerator(gen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addCellGenerators([gen1, gen2], after: gen2)

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.generators.isEmpty)
    }

    // MARK: - Table actions tests

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let gen1 = StubTableCellGenerator()
        let refillOne = XCTestExpectation(description: "refillOne")

        // Act 1
        ddm.addCellGenerator(gen1)
        ddm.forceRefill { [unowned self] in
            ddm.remove(gen1, with: .fade, needScrollAt: .top, needRemoveEmptySection: true)
            refillOne.fulfill()
        }

        wait(for: [refillOne], timeout: 1)

        // then
        XCTAssertEqual(ddm.sections.count, 0)
    }

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4])
        ddm.forceRefill()

        // when
        ddm.remove(gen3, with: .fade, needScrollAt: .top, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.scrollToRowWasCalled)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4])
        ddm.forceRefill()

        // when
        ddm.remove(gen1, with: .automatic, needScrollAt: nil, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertIdentical(ddm.generators.first?.first, gen2)
        XCTAssertEqual(ddm.generators.first?.count, 3)
    }

}
