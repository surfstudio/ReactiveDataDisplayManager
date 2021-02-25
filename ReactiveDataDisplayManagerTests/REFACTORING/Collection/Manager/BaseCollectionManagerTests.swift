//
//  BaseCollectionManagerTests.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseCollectionManagerTests: XCTestCase {

    // MARK: - Properties

    private var ddm: BaseCollectionManager!
    private var collection: UICollectionView!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        ddm = BaseCollectionManager()
        ddm.view = collection
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        ddm = nil
    }

    // MARK: - Initialization tests

    func testThatObjectPropertiesInitializeCorrectly() {
        // when
        let ddm = BaseCollectionManager()

        // then
        XCTAssert(ddm.generators.isEmpty)
        XCTAssert(ddm.sections.isEmpty)
        XCTAssertNil(ddm.delegate)
        XCTAssertNil(ddm.dataSource)
        XCTAssertNil(ddm.animator)
        XCTAssertNil(ddm.view)
    }

    // MARK: - Generator actions tests

    func testThatAddSectionGeneratorWorksCorrectly() {
        // given
        let gen1 = MockCollectionHeaderGenerator()
        let gen2 = MockCollectionHeaderGenerator()

        // when
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen1)
        ddm.addSectionHeaderGenerator(gen2)

        // then
        XCTAssert(ddm.sections.count == 3)
    }

    func testThatAddCellGeneratorAppendsNewSectionToCellGeneratorsCorrectly() {
        // given
        let headerGen = MockCollectionHeaderGenerator()
        let gen = MockCollectionCellGenerator()
        let initialNumberOfSections = ddm.generators.count

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen)

        // then
        XCTAssert(initialNumberOfSections != ddm.generators.count)
    }

    func testThatAddCellGeneratorAddsEmptyHeaderIfThereIsNoCellHeaderGenerators() {
        // given
        let gen = MockCollectionCellGenerator()

        // when
        ddm.addCellGenerator(gen)

        // then
        XCTAssert(ddm.sections.count == 1)
    }

    func testThatAddCellGeneratorAddsGeneratorCorrectly() {
        // given
        let headerGen = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen1)
        ddm.addSectionHeaderGenerator(headerGen)
        ddm.addCellGenerator(gen2)
        ddm.addCellGenerator(gen2)

        // then
        XCTAssert(ddm.generators.count == 2)
        XCTAssert(ddm.generators.first?.count == 3)
        XCTAssert(ddm.generators.last?.count == 2)
    }

    func testThatAddCellGeneratorAfterGeneratorWorksCorrectly() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        let headerGen2 = MockCollectionHeaderGenerator()
        let gen3 = MockCollectionCellGenerator()
        let gen4 = MockCollectionCellGenerator()
        let gen5 = MockCollectionCellGenerator()

        // when
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerator(gen1)
        ddm.addCellGenerator(gen2, after: gen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen5])
        ddm.addCellGenerator(gen4, after: gen3)

        // then
        XCTAssert(ddm.generators[0][0] === gen1 && ddm.generators[0][1] === gen2)
        XCTAssert(ddm.generators[1][0] === gen3 && ddm.generators[1][1] === gen4 && ddm.generators[1][2] === gen5)
    }

    func testThatAddCellGeneratorAfterGeneratorCallsFatalErrorCorrectly() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        self.ddm.addSectionHeaderGenerator(headerGen1)

        // when
        expectFatalError(expectedMessage: "Error adding cell generator. You tried to add generators after unexisted generator") {
            self.ddm.addCellGenerator(gen2, after: gen1) // then
        }
    }

    func testThatClearCellGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearCellGenerators()

        // then
        XCTAssert(ddm.generators.isEmpty)
    }

    func testThatClearHeaderGeneratorsWorksCorrectly() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen1, gen2, gen2])

        // when
        ddm.clearHeaderGenerators()

        // then
        XCTAssert(ddm.sections.isEmpty)
    }

    func testThatAddCellGeneratorToHeaderAddsGeneratorsToCorrectHeader() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        let headerGen2 = MockCollectionHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)

        // when
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen1, toHeader: headerGen1)
        ddm.addCellGenerator(gen2, toHeader: headerGen2)

        // then
        XCTAssert(ddm.generators.first?.count == 3)
        XCTAssert(ddm.generators.last?.count == 1)
    }

    func testThatRemoveGeneratorRemovesEmptySections() {
        // given
        let headerGen1 = MockCollectionHeaderGenerator()
        let gen1 = MockCollectionCellGenerator()
        let gen2 = MockCollectionCellGenerator()
        let headerGen2 = MockCollectionHeaderGenerator()
        let gen3 = MockCollectionCellGenerator()
        let gen4 = MockCollectionCellGenerator()

        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2], toHeader: headerGen1)
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4], toHeader: headerGen2)

        let group = DispatchGroup()
        group.enter()

        // when
        ddm.remove(gen3, needRemoveEmptySection: true) { group.leave() }
        ddm.remove(gen4, needRemoveEmptySection: true) { group.leave() }

        // then
        group.notify(queue: .main) { [weak self] in
            XCTAssert(self?.ddm.sections.count == 1)
            XCTAssert(self?.ddm.generators.count == 1)
        }
    }
    
}

// MARK: - Mocks

fileprivate final class MockCollectionHeaderGenerator: CollectionHeaderGenerator {

    var identifier: UICollectionReusableView.Type {
        return UICollectionReusableView.self
    }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }

    func registerHeader(in collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.registerNib(self.identifier, kind: UICollectionView.elementKindSectionHeader)
        }
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return .zero
    }

}

fileprivate final class MockCollectionCellGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: UICollectionViewCell.self)
    }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func registerCell(in collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.registerNib(self.identifier)
        }
    }

}
