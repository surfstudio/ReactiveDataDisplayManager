// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast file_length

import XCTest
@testable import ReactiveDataDisplayManager

final class ManualTableManagerTests: XCTestCase {

    private var ddm: ManualTableManager!
    private var table: SpyUITableView!
    private var dataSource: MockTableDataSource!

    override func setUp() {
        super.setUp()
        table = SpyUITableView()
        ddm = table.rddm.manualBuilder
            .set(dataSource: {
                dataSource = MockTableDataSource(manager: $0)
                return dataSource
            })
            .build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
        dataSource = nil
    }

    // MARK: - Generator actions tests

    func testThatAddSectionGeneratorWorksCorrectly() {
        // given
        let gen1 = StubTableHeaderGenerator()
        let gen2 = StubTableHeaderGenerator()
        let expectation = XCTestExpectation(description: "forceRefill")

        // when
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen2)
        ddm.forceRefill { expectation.fulfill() }

        wait(for: [expectation], timeout: 3)

        // then
        XCTAssertEqual(ddm.sections.count, 3)
        XCTAssertEqual(dataSource.numberOfSections(in: table), 3)
    }

    func testThatAddSectionWithGenerators() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let initialNumberOfSections = ddm.sections.count

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2])
        ddm.addSection(TableHeaderGenerator: headerGen2, cells: [gen3, gen4, gen5])

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.sections.count)
        XCTAssertTrue(ddm.sections[1] === headerGen2)
        XCTAssertEqual(ddm.generators[1].count, 3)
    }

    func testThatInsertSectionHeaderAfterSectionHeaderCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()
        let headerGen4 = StubTableHeaderGenerator()
        let headerGen5 = StubTableHeaderGenerator()
        let headerGen6 = StubTableHeaderGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addSectionHeaderGenerator(headerGen3)

        ddm.insert(headGenerator: headerGen4, after: headerGen1)
        ddm.insert(headGenerator: headerGen5, after: headerGen2)
        ddm.insert(headGenerator: headerGen6, after: headerGen5)
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm.sections[1] === headerGen4)
        XCTAssertTrue(ddm.sections[3] === headerGen5)
        XCTAssertTrue(ddm.sections[5] === headerGen3)
    }

    func testThatInsertSectionHeaderBeforeSectionHeaderCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()
        let headerGen4 = StubTableHeaderGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addSectionHeaderGenerator(headerGen3)

        ddm.insert(headGenerator: headerGen4, before: headerGen1)
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm.sections[0] === headerGen4)
        XCTAssertTrue(ddm.sections[1] === headerGen1)
    }

    func testThatInsertSectionHeaderWithGeneratorsAfterSectionHeaderCorrectly() {
        // given
        let expect = expectation(description: "reloading")
        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()
        let headerGen4 = StubTableHeaderGenerator()
        let headerGen5 = StubTableHeaderGenerator()
        let headerGen6 = StubTableHeaderGenerator()

        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addSectionHeaderGenerator(headerGen3)

        ddm.insertSection(after: headerGen1, new: headerGen4, generators: [gen1])
        ddm.insertSection(after: headerGen2, new: headerGen5, generators: [gen2, gen3, gen4])
        ddm.insertSection(after: headerGen5, new: headerGen6, generators: [gen5, gen6])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(self.ddm?.sections[0] === headerGen1)
        XCTAssertTrue(self.ddm?.sections[3] === headerGen5)
        XCTAssertTrue(self.ddm?.sections[1] === headerGen4)
        XCTAssertEqual(self.ddm?.generators[1].count, 1)
        XCTAssertEqual(self.ddm?.generators[3].count, 3)
        XCTAssertEqual(self.ddm?.generators[4].count, 2)
    }

    func testThatInsertSectionHeaderWithGeneratorsBeforeSectionHeaderCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()

        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.insertSection(before: headerGen1, new: headerGen3, generators: [gen1, gen2, gen3])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(ddm.sections[0], headerGen3)
        XCTAssertIdentical(ddm.sections[1], headerGen1)
        XCTAssertEqual(ddm.generators[0].count, 3)
        XCTAssertEqual(ddm.generators[1].count, 0)
    }

    func testThatInsertSectionHeaderWithGeneratorsByIndexCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()
        let headerGen4 = StubTableHeaderGenerator()
        let headerGen5 = StubTableHeaderGenerator()

        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addSectionHeaderGenerator(headerGen3)

        ddm.insert(headGenerator: headerGen4, by: 1, generators: [gen1])
        ddm.insert(headGenerator: headerGen5, by: 0, generators: [gen2, gen3, gen4])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(self.ddm?.sections[2], headerGen4)
        XCTAssertIdentical(self.ddm?.sections[0], headerGen5)
        XCTAssertEqual(self.ddm?.generators[2].count, 1)
        XCTAssertEqual(self.ddm?.generators[0].count, 3)
    }

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator()
        let initialNumberOfSections = ddm.generators.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.generators.count)
    }

    func testThatAddCellGeneratorCallsRegisterNib() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertTrue(table.registerNibWasCalled)
    }

    func testThatCustomOperationAddCellGeneratorCallsRegisterNib() {
        // Arrange
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator()

        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += gen

        // Assert
        XCTAssertTrue(table.registerNibWasCalled)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let headerGen = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += [gen1, gen2]

        // Assert
        XCTAssertTrue(table.registerNibWasCalled)
        XCTAssertEqual(ddm.generators[0].count, 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = StubTableCellGenerator()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen2)
        ddm.addCellGenerator(gen2)

        // then
        XCTAssertEqual(ddm.generators.count, 2)
        XCTAssertEqual(ddm.generators.first?.count, 3)
        XCTAssertEqual(ddm.generators.last?.count, 2)
    }

    func testThatAddCellGeneratorToHeaderCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen)
        ddm.addCellGenerator(gen2, toHeader: headerGen)

        // then
        XCTAssertEqual(ddm.generators.first?.count, 5)
        XCTAssertEqual(ddm.generators.last?.count, 3)
        XCTAssertIdentical(ddm.generators.first?[3], gen2)
    }

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen5])
        ddm.addCellGenerator(gen4, after: gen3)

        // then
        XCTAssertTrue(ddm.generators[0][0] === gen1 && ddm.generators[0][1] === gen2)
        XCTAssertTrue(ddm.generators[1][0] === gen3 && ddm.generators[1][1] === gen4 && ddm.generators[1][2] === gen5)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        self.ddm.addSectionHeaderGenerator(headerGen1)

        // when
        expectFatalError(expectedMessage: "Error adding TableCellGenerator generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.generators.isEmpty)
    }

    func testThatClearHeaderGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearHeaderGenerators()

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
    }

    func testThatAddCellGeneratorToHeaderAddsGeneratorsToCorrectHeader() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)

        // when
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen2)

        // then
        XCTAssertEqual(ddm.generators.first?.count, 3)
        XCTAssertEqual(ddm.generators.last?.count, 1)
    }

    // MARK: - Table actions tests

    func testThatInsertGeneratorAfterGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen4, gen6], toHeader: headerGen2)

        // when
        ddm?.insert(after: gen1, new: gen2)
        ddm?.insert(after: gen4, new: gen5)
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][0] === gen1 && ddm?.generators[0][1] === gen2 && ddm?.generators[0][2] === gen3)
        XCTAssertTrue(ddm?.generators[1][0] === gen4 && ddm?.generators[1][1] === gen5 && ddm?.generators[1][2] === gen6)
    }

    func testThatInsertGeneratorsAfterGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen4, gen6], toHeader: headerGen2)

        // when
        ddm.insert(after: gen1, new: [gen2, gen1, gen3])
        ddm.insert(after: gen4, new: [gen5, gen4, gen6])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm.generators[0][0] === gen1 && ddm.generators[0][1] === gen2 && ddm.generators[0][2] === gen1)
        XCTAssertTrue(ddm.generators[1][0] === gen4 && ddm.generators[1][1] === gen5 && ddm.generators[1][2] === gen4)
    }

    func testThatInsertGeneratorBeforeGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)

        // when
        ddm.insert(before: gen2, new: gen1)
        ddm.insert(before: gen5, new: gen4)
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][0] === gen1 && ddm?.generators[0][1] === gen2 && ddm?.generators[0][2] === gen3)
        XCTAssertTrue(ddm?.generators[1][0] === gen4 && ddm?.generators[1][1] === gen5 && ddm?.generators[1][2] === gen6)
    }

    func testThatInsertGeneratorsBeforeGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)

        // when
        ddm.insert(before: gen2, new: [gen1, gen2, gen3])
        ddm.insert(before: gen5, new: [gen4, gen5, gen6])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][0] === gen1 && ddm?.generators[0][1] === gen2 && ddm?.generators[0][2] === gen3)
        XCTAssertTrue(ddm?.generators[1][0] === gen4 && ddm?.generators[1][1] === gen5 && ddm?.generators[1][2] === gen6)
    }

    func testThatInsertGeneratorToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)

        // when
        ddm.insert(to: headerGen1, new: gen1)
        ddm.insert(to: headerGen2, new: gen4)
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][0] === gen1 && ddm?.generators[0][1] === gen2 && ddm?.generators[0][2] === gen3)
        XCTAssertTrue(ddm?.generators[1][0] === gen4 && ddm?.generators[1][1] === gen5 && ddm?.generators[1][2] === gen6)
    }

    func testThatInsertAtBeginningGeneratorsToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)

        // when
        ddm.insertAtBeginning(to: headerGen1, new: [gen1, gen5, gen6])
        ddm.insertAtBeginning(to: headerGen2, new: [gen4, gen2, gen3])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][0] === gen1 && ddm?.generators[0][1] === gen5 && ddm?.generators[0][2] === gen6)
        XCTAssertTrue(ddm?.generators[1][0] === gen4 && ddm?.generators[1][1] === gen2 && ddm?.generators[1][2] === gen3)
    }

    func testThatInsertAtEndGeneratorsToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator()
        let gen5 = StubTableCellGenerator()
        let gen6 = StubTableCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen2, gen3], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen5, gen6], toHeader: headerGen2)

        // when
        ddm.insertAtEnd(to: headerGen1, new: [gen1, gen5, gen6])
        ddm.insertAtEnd(to: headerGen2, new: [gen4, gen2, gen3])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertTrue(ddm?.generators[0][2] === gen1 && ddm?.generators[0][3] === gen5 && ddm?.generators[0][4] === gen6)
        XCTAssertTrue(ddm?.generators[1][2] === gen4 && ddm?.generators[1][3] === gen2 && ddm?.generators[1][4] === gen3)
    }

    func testThatReplaceOldGeneratorOnNewReplacesGeneratorCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let gen3 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)

        // when
        ddm.replace(oldGenerator: gen1, on: gen3)

        // then
        XCTAssertTrue(ddm.generators[0][0] === gen3 && ddm.generators[0][1] === gen2)
    }

    func testThatSwapGeneratorWithGeneratorSwapsCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen2 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)

        // when
        ddm.swap(generator: gen1, with: gen2)

        // then
        XCTAssertTrue(ddm.generators[0][0] === gen2 && ddm.generators[1][0] === gen1)
    }

    func testThatRemoveAllGeneratorsClearsSection() {
        // Arrange
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen2 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)

        // Act
        ddm.removeAllGenerators(from: headerGen2)

        // Assert
        XCTAssertEqual(table.numberOfSections, 2)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
        XCTAssertEqual(table.numberOfRows(inSection: 1), 0, "Expected 0, got \(table.numberOfRows(inSection: 1))")
    }

    func testThatRemoveAllGeneratorsDoesntClearInvalidSection() {
        // Arrange
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)

        // Act
        ddm.removeAllGenerators(from: headerGen2)

        // Assert
        XCTAssertEqual(table.numberOfSections, 1)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(table.numberOfRows(inSection: 0), 1, "Expected 1, got \(table.numberOfRows(inSection: 0))")
    }

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, with: .automatic, needScrollAt: nil, needRemoveEmptySection: true)
        ddm.remove(gen4, with: .automatic, needScrollAt: nil, needRemoveEmptySection: true)
        ddm.forceRefill()

        XCTAssertEqual(ddm.sections.count, 1)
        XCTAssertEqual(ddm.generators.count, 1)
    }

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, with: .top, needScrollAt: .top, needRemoveEmptySection: true)
        ddm.forceRefill()

        //then
        XCTAssertTrue(table.scrollToRowWasCalled)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator()
        let gen2 = StubTableCellGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator()
        let gen4 = StubTableCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen1, with: .automatic, needScrollAt: .top, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertIdentical(ddm.generators.first?.first, gen2)
        XCTAssertEqual(ddm.generators.first?.count, 1)
    }

}
