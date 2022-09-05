// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseCollectionManagerTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var ddm: BaseCollectionManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        ddm = collection.rddm.baseBuilder.build()
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        ddm = nil
    }

    // MARK: - Initialization tests

    func testThatObjectPropertiesInitializeCorrectly() {

        // then
        XCTAssertTrue(ddm.sections.isEmpty)
        XCTAssertNotNil(ddm.delegate)
        XCTAssertNotNil(ddm.dataSource)
        XCTAssertNotNil(ddm.view)
    }

    // MARK: - Generator actions tests

    func testThatAddSectionGeneratorWorksCorrectly() {
        // given
        let gen1 = CollectionHeaderGeneratorMock()
        let gen2 = CollectionHeaderGeneratorMock()

        // when
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen2)

        // then
        XCTAssertEqual(ddm.sections.count, 3)
    }

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = CollectionHeaderGeneratorMock()
        let gen = Mocks.collectionCell()
        let initialNumberOfSections = ddm.sections.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.sections.count)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = Mocks.collectionCell()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()

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

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        let headerGen2 = CollectionHeaderGeneratorMock()
        let gen3 = Mocks.collectionCell()
        let gen4 = Mocks.collectionCell()
        let gen5 = Mocks.collectionCell()

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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        self.ddm.addSectionHeaderGenerator(headerGen1)

        // when
        expectFatalError(expectedMessage: "Error adding cell generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        let headerGen2 = CollectionHeaderGeneratorMock()
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

    func testThatInsertGeneratorInsertionSuccess() {
        // given
        let expect = expectation(description: "reloading")

        let gen0 = Mocks.collectionCell()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        let gen3 = Mocks.collectionCell()
        let gen4 = Mocks.collectionCell()

        ddm.clearCellGenerators()
        ddm.addCellGenerators([gen0, gen1, gen2])

        // when
        ddm.insert(after: gen1, new: [gen3, gen4])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(ddm?.sections[0].generators[2], gen3)
        XCTAssertIdentical(ddm?.sections[0].generators[3], gen4)
        XCTAssertEqual(ddm.sections.first?.generators.count, 5)
    }

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let headerGen2 = CollectionHeaderGeneratorMock()
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        let gen3 = Mocks.collectionCell()
        let gen4 = Mocks.collectionCell()

        ddm.clearCellGenerators()
        ddm.clearCellGenerators()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)
        collection.layoutSubviews()

        // when
        ddm.remove(gen2, needScrollAt: .top, needRemoveEmptySection: true)
        ddm.remove(gen1, needScrollAt: .top, needRemoveEmptySection: true)

        // then
        XCTAssertEqual(ddm?.sections.count, 1)
    }

    func testThatCustomOperationAddCellGenerator() {
        // given
        let gen1 = Mocks.collectionCell()
        let gen2 = Mocks.collectionCell()
        let gen3 = Mocks.collectionCell()
        let gen4 = Mocks.collectionCell()

        ddm.clearCellGenerators()
        ddm.clearCellGenerators()

        // when
        ddm += gen1
        ddm += [gen2, gen3, gen4]

        // then
        XCTAssertIdentical(ddm.sections.first?.generators.first, gen1)
        XCTAssertIdentical(ddm.sections.first?.generators.last, gen4)
        XCTAssertEqual(ddm?.sections.first?.generators.count, 4)
    }

}
