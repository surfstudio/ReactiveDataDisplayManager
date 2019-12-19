//
//  BaseCollectionDataDisplayManagerTests.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseCollectionDataDisplayManagerTests: XCTestCase {

    // MARK: - Mocks

    final class HeaderGenerator: CollectionHeaderGenerator {
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

    final class CellGenerator: CollectionCellGenerator {
        var identifier: UICollectionViewCell.Type {
            return UICollectionViewCell.self
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

    // MARK: - Properties

    private var ddm: BaseCollectionDataDisplayManager!
    private var collection: UICollectionView!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        ddm = BaseCollectionDataDisplayManager(collection: collection)
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        ddm = nil
    }

    // MARK: - Initialization tests

    func testThatObjectPropertiesInitializeCorrectly() {
        // given
        let collection = UITableView()
        // when
        let ddm = BaseTableDataDisplayManager(collection: collection)
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
}
