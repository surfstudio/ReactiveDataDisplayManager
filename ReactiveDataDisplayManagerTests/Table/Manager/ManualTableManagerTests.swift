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
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")
        let gen5 = StubTableCellGenerator(model: "13")
        let initialNumberOfSections = ddm.sections.count

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2])
        ddm.addSection(TableHeaderGenerator: headerGen2, cells: [gen3, gen4, gen5])

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.sections.count)
        XCTAssertIdentical(ddm.sections[1].header, headerGen2)
        XCTAssertEqual(ddm.sections[1].generators.count, 3)
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
        XCTAssertIdentical(ddm.sections[1].header, headerGen4)
        XCTAssertIdentical(ddm.sections[3].header, headerGen5)
        XCTAssertIdentical(ddm.sections[5].header, headerGen3)
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
        XCTAssertIdentical(ddm.sections[0].header, headerGen4)
        XCTAssertIdentical(ddm.sections[1].header, headerGen1)
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

        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let gen4 = StubTableCellGenerator(model: "4")
        let gen5 = StubTableCellGenerator(model: "5")
        let gen6 = StubTableCellGenerator(model: "6")

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
        XCTAssertIdentical(self.ddm?.sections[0].header, headerGen1)
        XCTAssertIdentical(self.ddm?.sections[3].header, headerGen5)
        XCTAssertIdentical(self.ddm?.sections[1].header, headerGen4)
        XCTAssertEqual(self.ddm?.sections[1].generators.count, 1)
        XCTAssertEqual(self.ddm?.sections[3].generators.count, 3)
        XCTAssertEqual(self.ddm?.sections[4].generators.count, 2)
    }

    func testThatInsertSectionHeaderWithGeneratorsBeforeSectionHeaderCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()

        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.insertSection(before: headerGen1, new: headerGen3, generators: [gen1, gen2, gen3])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(ddm.sections[0].header, headerGen3)
        XCTAssertIdentical(ddm.sections[1].header, headerGen1)
        XCTAssertEqual(ddm.sections[0].generators.count, 3)
        XCTAssertEqual(ddm.sections[1].generators.count, 0)
    }

    func testThatInsertSectionHeaderWithGeneratorsByIndexCorrectly() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let headerGen2 = StubTableHeaderGenerator()
        let headerGen3 = StubTableHeaderGenerator()
        let headerGen4 = StubTableHeaderGenerator()
        let headerGen5 = StubTableHeaderGenerator()

        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let gen4 = StubTableCellGenerator(model: "4")

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addSectionHeaderGenerator(headerGen3)

        ddm.insert(headGenerator: headerGen4, by: 1, generators: [gen1])
        ddm.insert(headGenerator: headerGen5, by: 0, generators: [gen2, gen3, gen4])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(self.ddm?.sections[2].header, headerGen4)
        XCTAssertIdentical(self.ddm?.sections[0].header, headerGen5)
        XCTAssertEqual(self.ddm?.sections[2].generators.count, 1)
        XCTAssertEqual(self.ddm?.sections[0].generators.count, 3)
    }

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator(model: "1")
        let initialNumberOfSections = ddm.sections.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.sections.count)
    }

    func testThatAddCellGeneratorCallsRegisterNib() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator(model: "1")

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)
        ddm.forceRefill()

        // then
        XCTAssertTrue(table.registerWasCalled)
    }

    func testThatCustomOperationAddCellGeneratorCallsRegisterNib() {
        // Arrange
        let headerGen = StubTableHeaderGenerator()
        let gen = StubTableCellGenerator(model: "1")

        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += gen
        ddm.forceRefill()

        // Assert
        XCTAssertTrue(table.registerWasCalled)
    }

    func testThatCustomOperationAddCellGeneratorsCallsRegisterNib() {
        // Arrange
        let headerGen = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        // Act
        ddm.addSectionHeaderGenerator(headerGen)
        ddm += [gen1, gen2]
        ddm.forceRefill()

        // Assert
        XCTAssertTrue(table.registerWasCalled)
        XCTAssertEqual(ddm.sections[0].generators.count, 2)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = StubTableCellGenerator(model: "1")

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen2)
        ddm.addCellGenerator(gen2)

        // then
        XCTAssertEqual(ddm.sections.count, 2)
        XCTAssertEqual(ddm.sections.first?.generators.count, 3)
        XCTAssertEqual(ddm.sections.last?.generators.count, 2)
    }

    func testThatAddCellGeneratorToHeaderCorrectly() {
        // given
        let headerGen = StubTableHeaderGenerator()
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")

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
        XCTAssertEqual(ddm.sections.first?.generators.count, 5)
        XCTAssertEqual(ddm.sections.last?.generators.count, 3)
        XCTAssertIdentical(ddm.sections.first?.generators[3], gen2)
    }

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")
        let gen5 = StubTableCellGenerator(model: "13")

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen5])
        ddm.addCellGenerator(gen4, after: gen3)

        // then
        XCTAssertIdentical(ddm.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm.sections[1].generators[0], gen3)
        XCTAssertIdentical(ddm.sections[1].generators[1], gen4)
        XCTAssertIdentical(ddm.sections[1].generators[2], gen5)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        self.ddm.addSectionHeaderGenerator(headerGen1)

        // when
        expectFatalError(expectedMessage: "Error adding TableCellGenerator generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
    }

    func testThatClearHeaderGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
    }

    func testThatAddCellGeneratorToHeaderAddsGeneratorsToCorrectHeader() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)

        // when
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen2)

        // then
        XCTAssertEqual(ddm.sections.first?.generators.count, 3)
        XCTAssertEqual(ddm.sections.last?.generators.count, 1)
    }

    // MARK: - Table actions tests

    func testThatInsertGeneratorAfterGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")
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
        XCTAssertIdentical(ddm?.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen3)
        XCTAssertIdentical(ddm?.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[1], gen5)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen6)
    }

    func testThatInsertGeneratorsAfterGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")
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
        XCTAssertIdentical(ddm.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm.sections[0].generators[2], gen1)
        XCTAssertIdentical(ddm.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm.sections[1].generators[1], gen5)
        XCTAssertIdentical(ddm.sections[1].generators[2], gen4)
    }

    func testThatInsertGeneratorBeforeGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")
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
        XCTAssertIdentical(ddm?.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen3)
        XCTAssertIdentical(ddm?.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[1], gen5)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen6)
    }

    func testThatInsertGeneratorsBeforeGeneratorInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")
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
        XCTAssertIdentical(ddm?.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen3)
        XCTAssertIdentical(ddm?.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[1], gen5)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen6)
    }

    func testThatInsertGeneratorToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")

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
        XCTAssertIdentical(ddm?.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[1], gen2)
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen3)
        XCTAssertIdentical(ddm?.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[1], gen5)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen6)
    }

    func testThatInsertAtBeginningGeneratorsToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")

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
        XCTAssertIdentical(ddm?.sections[0].generators[0], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[1], gen5)
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen6)
        XCTAssertIdentical(ddm?.sections[1].generators[0], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[1], gen2)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen3)
    }

    func testThatInsertAtEndGeneratorsToHeaderInsertsGeneratorOnCorrectPosition() {
        // given
        let expect = expectation(description: "reloading")

        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        let headerGen2 = StubTableHeaderGenerator()
        let gen4 = StubTableCellGenerator(model: "11")
        let gen5 = StubTableCellGenerator(model: "12")
        let gen6 = StubTableCellGenerator(model: "13")

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
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen1)
        XCTAssertIdentical(ddm?.sections[0].generators[3], gen5)
        XCTAssertIdentical(ddm?.sections[0].generators[4], gen6)
        XCTAssertIdentical(ddm?.sections[1].generators[2], gen4)
        XCTAssertIdentical(ddm?.sections[1].generators[3], gen2)
        XCTAssertIdentical(ddm?.sections[1].generators[4], gen3)
    }

    func testThatReplaceOldGeneratorOnNewReplacesGeneratorCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let gen3 = StubTableCellGenerator(model: "3")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)

        // when
        ddm.replace(oldGenerator: gen1, on: gen3)

        // then
        XCTAssertIdentical(ddm.sections[0].generators[0], gen3)
        XCTAssertIdentical(ddm.sections[0].generators[1], gen2)
    }

    func testThatSwapGeneratorWithGeneratorSwapsCorrectly() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let headerGen2 = StubTableHeaderGenerator()
        let gen2 = StubTableCellGenerator(model: "11")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen2], toHeader: headerGen2)

        // when
        ddm.swap(generator: gen1, with: gen2)

        // then
        XCTAssertIdentical(ddm.sections[0].generators[0], gen2)
        XCTAssertIdentical(ddm.sections[1].generators[0], gen1)
    }

    func testThatRemoveAllGeneratorsClearsSection() {
        // Arrange
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let headerGen2 = StubTableHeaderGenerator()
        let gen2 = StubTableCellGenerator(model: "11")
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
        let gen1 = StubTableCellGenerator(model: "11")
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
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, with: .notAnimated, needScrollAt: nil, needRemoveEmptySection: true)
        ddm.remove(gen4, with: .notAnimated, needScrollAt: nil, needRemoveEmptySection: true)
        ddm.forceRefill()

        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatRemoveGeneratorCallsScrolling() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen3, with: .animated(.top), needScrollAt: .top, needRemoveEmptySection: true)
        ddm.forceRefill()

        //then
        XCTAssertTrue(table.scrollToRowWasCalled)
    }

    func testThatRemoveGeneratorRemovesGenerators() {
        // given
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        ddm.forceRefill()

        // when
        ddm.remove(gen1, with: .notAnimated, needScrollAt: .top, needRemoveEmptySection: false)
        ddm.forceRefill()

        // then
        XCTAssertIdentical(ddm.sections.first?.generators.first, gen2)
        XCTAssertEqual(ddm.sections.first?.generators.count, 1)
    }

}
