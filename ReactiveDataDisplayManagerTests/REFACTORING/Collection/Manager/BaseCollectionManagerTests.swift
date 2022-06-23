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
        XCTAssertTrue(ddm.generators.isEmpty)
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
        let gen = CollectionCellGeneratorMock()
        let initialNumberOfSections = ddm.generators.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssertNotEqual(initialNumberOfSections, ddm.generators.count)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = CollectionCellGeneratorMock()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssertEqual(ddm.sections.count, 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()

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

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        let headerGen2 = CollectionHeaderGeneratorMock()
        let gen3 = CollectionCellGeneratorMock()
        let gen4 = CollectionCellGeneratorMock()
        let gen5 = CollectionCellGeneratorMock()

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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        self.ddm.addSectionHeaderGenerator(headerGen1)

        // when
        expectFatalError(expectedMessage: "Error adding cell generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
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
        let headerGen1 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        let headerGen2 = CollectionHeaderGeneratorMock()
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

    func testThatInsertGeneratorInsertionSuccess() {
        // given
        let expect = expectation(description: "reloading")

        let gen0 = CollectionCellGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        let gen3 = CollectionCellGeneratorMock()
        let gen4 = CollectionCellGeneratorMock()

        ddm.clearCellGenerators()
        ddm.addCellGenerators([gen0, gen1, gen2])

        // when
        ddm.insert(after: gen1, new: [gen3, gen4])
        ddm.forceRefill { expect.fulfill() }

        wait(for: [expect], timeout: 3)

        // then
        XCTAssertIdentical(ddm?.generators[0][2], gen3)
        XCTAssertIdentical(ddm?.generators[0][3], gen4)
        XCTAssertEqual(ddm.generators.first?.count, 5)
    }

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = CollectionHeaderGeneratorMock()
        let headerGen2 = CollectionHeaderGeneratorMock()
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        let gen3 = CollectionCellGeneratorMock()
        let gen4 = CollectionCellGeneratorMock()

        ddm.clearHeaderGenerators()
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
        XCTAssertEqual(ddm?.generators.count, 1)
    }

    func testThatCustomOperationAddCellGenerator() {
        // given
        let gen1 = CollectionCellGeneratorMock()
        let gen2 = CollectionCellGeneratorMock()
        let gen3 = CollectionCellGeneratorMock()
        let gen4 = CollectionCellGeneratorMock()

        ddm.clearHeaderGenerators()
        ddm.clearCellGenerators()

        // when
        ddm += gen1
        ddm += [gen2, gen3, gen4]

        // then
        XCTAssertIdentical(ddm.generators.first?.first, gen1)
        XCTAssertIdentical(ddm.generators.first?.last, gen4)
        XCTAssertEqual(ddm?.generators.first?.count, 4)
    }


}
