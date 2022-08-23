// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class GravityTableManagerTests: XCTestCase {

    private var ddm: GravityTableManager!
    private var table: SpyUITableView!

    override func setUp() {
        super.setUp()
        table = SpyUITableView()
        ddm = table.rddm.gravityBuilder
            .set(dataSource: { MockTableDataSource(manager: $0) })
            .build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
    }

    // MARK: - Generator actions tests

    func testThatAddSectionGeneratorWorksCorrectly() {
        // given
        let gen1 = MockGravityTableHeaderGenerator(heaviness: 10)
        let gen2 = MockGravityTableHeaderGenerator(heaviness: 5)

        // when
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen2)

        // then
        XCTAssertIdentical(ddm.sections[0].header, gen2)
        XCTAssertIdentical(ddm.sections[1].header, gen1)
    }

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = MockGravityTableHeaderGenerator()
        let gen = MockGravityTableCellGenerator()
        let initialNumberOfSections = ddm.generators.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.generators.count)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let headerGen = MockGravityTableHeaderGenerator()
        let gen1 = MockGravityTableCellGenerator(heaviness: 3)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)

        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += [gen2, gen1]

        // Assert
        XCTAssertTrue(table.registerWasCalled)
        XCTAssertIdentical(ddm.generators[0][0], gen2)
        XCTAssertIdentical(ddm.generators[0][1], gen1)
        XCTAssertEqual(ddm.generators[0].count, 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = MockGravityTableCellGenerator()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 4)

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen2)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerator(gen4)
        ddm.addCellGenerator(gen3)

        // then
        XCTAssertIdentical(ddm.generators[1][0], gen3)
        XCTAssertIdentical(ddm.generators[0][0], gen1)
        XCTAssertEqual(ddm.generators.first?.count, 2)
    }

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 5)
        let gen5 = MockGravityTableCellGenerator(heaviness: 4)

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen5])
        ddm.addCellGenerator(gen4, after: gen3)

        // then
        XCTAssertIdentical(ddm.generators[0][0], gen1)
        XCTAssertIdentical(ddm.generators[0][1], gen2)
        XCTAssertIdentical(ddm.generators[1][0], gen3)
        XCTAssertIdentical(ddm.generators[1][1], gen4)
        XCTAssertIdentical(ddm.generators[1][2], gen5)
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator()
        let gen2 = MockGravityTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.generators.isEmpty)
    }

    func testThatClearHeaderGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator()
        let gen2 = MockGravityTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
    }

    func testThatAddCellGeneratorToHeaderAddsGeneratorsToCorrectHeader() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 4)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)

        // when
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen3, toHeader: headerGen1)
        ddm.addCellGenerator(gen4, toHeader: headerGen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen2)

        // then
        XCTAssertEqual(ddm.generators.first?.count, 3)
        XCTAssertEqual(ddm.generators.last?.count, 1)
    }

    // MARK: - Table actions tests

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 4)

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, needRemoveEmptySection: true) //{ group.leave() }
        ddm.remove(gen4, needRemoveEmptySection: true) //{ group.leave() }
        ddm.forceRefill()

        // then
        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.generators.count, 1)
    }

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 4)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, needScrollAt: .top)
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.scrollToRowWasCalled)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator(heaviness: 1)
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        let gen4 = MockGravityTableCellGenerator(heaviness: 4)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen1)
        ddm.forceRefill()

        // then
        XCTAssertIdentical(ddm.generators.first?.first, gen2)
        XCTAssertEqual(ddm.generators.first?.count, 1)
    }

    func testThatReplaceOldGeneratorOnNewReplacesGeneratorCorrectly() {
        // given
        let headerGen1 = MockGravityTableHeaderGenerator()
        let gen1 = MockGravityTableCellGenerator(heaviness: 1)
        let gen2 = MockGravityTableCellGenerator(heaviness: 2)
        let gen3 = MockGravityTableCellGenerator(heaviness: 3)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)

        // when
        ddm.replace(oldGenerator: gen1, on: gen3)

        // then
        XCTAssertIdentical(ddm.generators[0][0], gen3)
        XCTAssertIdentical(ddm.generators[0][1], gen2)
    }

    func testThatRemoveAllGeneratorsClearsSection() {
        // Arrange
        let headerGen1 = MockGravityTableHeaderGenerator()
        let gen1 = MockGravityTableCellGenerator()
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        let gen2 = MockGravityTableCellGenerator(heaviness: 1)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)

        // Act
        ddm.removeAllgenerators(from: headerGen2)

        // Assert
        XCTAssertEqual(table.numberOfSections, 2)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
        XCTAssertEqual(table.numberOfRows(inSection: 1), 0, "Expected 0, got \(table.numberOfRows(inSection: 1))")
    }

    func testThatRemoveAllGeneratorsDoesntClearInvalidSection() {
        // Arrange
        let headerGen1 = MockGravityTableHeaderGenerator()
        let gen1 = MockGravityTableCellGenerator()
        let headerGen2 = MockGravityTableHeaderGenerator(heaviness: 2)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)

        // Act
        ddm.removeAllgenerators(from: headerGen2)

        // Assert
        XCTAssertEqual(table.numberOfSections, 1)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
    }

}
