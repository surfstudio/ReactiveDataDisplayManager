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
        XCTAssertTrue(ddm.sections.isEmpty)
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
        let gen = StubTableCellGenerator(model: "1")

        // when
        ddm.addCellGenerator(gen)
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.registerWasCalled)
        XCTAssertEqual(ddm.sections.first?.generators.count, 1)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        // Act
        ddm += [gen1, gen2]
        ddm.forceRefill()

        // Assert
        XCTAssertTrue(table.registerWasCalled)
        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.sections.first?.generators.count, 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = StubTableCellGenerator(model: "1")

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.sections.first?.generators.count, 1)
    }

    func testThatAddCellGeneratorAfterGenerator() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)

        // when
        XCTAssertEqual(ddm.sections.first?.generators.count, 2)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        // when
        expectFatalError(expectedMessage: "Error adding TableCellGenerator generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // Then
        }
    }

    func testThatUpdateGeneratorsUpdatesNeededGenerators() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let gen4 = StubTableCellGenerator(model: "4")
        let gen5 = StubTableCellGenerator(model: "5")

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4, gen5])

        // when
        ddm.update(generators: [gen1, gen4])

        // then
        XCTAssertEqual(table.lastReloadedRows, [IndexPath(row: 0, section: 0), IndexPath(row: 3, section: 0)])
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        ddm.addCellGenerator(gen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addCellGenerators([gen1, gen2], after: gen2)

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
    }

    // MARK: - Table actions tests

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4])
        ddm.forceRefill()

        table.forceLayout()

        // when
        ddm.remove(gen3, with: nil, needScrollAt: .top, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.scrollToRowWasCalled)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")

        ddm.addCellGenerators([gen1, gen2])
        ddm.addCellGenerators([gen3, gen4])
        ddm.forceRefill()

        table.forceLayout()

        // when
        ddm.remove(gen1, with: nil, needScrollAt: nil, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertIdentical(ddm.sections.first?.generators.first, gen2)
        XCTAssertEqual(ddm.sections.first?.generators.count, 3)
    }

}
