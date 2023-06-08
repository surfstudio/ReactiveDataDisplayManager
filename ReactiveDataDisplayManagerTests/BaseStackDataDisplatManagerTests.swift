//
//  BaseStackDataDisplatManagerTests.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class TitleStackCellGenerator: StackCellGenerator {

    var title: String

    var view: UIView?

    init(title: String) {
        self.title = title
    }
}

// MARK: - StackCellGenerator

extension TitleStackCellGenerator: ViewBuilder {
    func build(view: UILabel) {
        self.view = view
        view.text = title
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}

final class BaseStackDataDisplayManagerTests: XCTestCase {

    private var ddm: BaseStackDataDisplayManager!
    private var stackView: UIStackView!

    override func setUp() {
        super.setUp()
        stackView = UIStackView()
        ddm = BaseStackDataDisplayManager(collection: stackView)
    }

    override func tearDown() {
        super.tearDown()
        stackView = nil
        ddm = nil
    }

    func testAddingOneGenerator() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")

        // when

        ddm.addCellGenerator(generator1)
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews.count, 1)
    }

    func testAddingMultipleGenerators() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when

        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews.count, generators.count)
    }

    func testAddingOneGeneratorAfterAnotherGenerators() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]
        let generator5 = TitleStackCellGenerator(title: "After Two")

        // when

        ddm.addCellGenerators(generators)
        ddm.addCellGenerator(generator5, after: generator2)
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews[2], generator5.view)
    }

    func testAddingMultipleGeneratorAfterAnotherGenerators() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]
        let generator5 = TitleStackCellGenerator(title: "After Two")
        let generator6 = TitleStackCellGenerator(title: "After Two")
        let generator7 = TitleStackCellGenerator(title: "After Two")
        let generator8 = TitleStackCellGenerator(title: "After Two")
        let generatorsAfterTwo = [generator5, generator6, generator7, generator8]

        // when

        ddm.addCellGenerators(generators)
        ddm.addCellGenerators(generatorsAfterTwo, after: generator2)
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews[2], generator5.view)
        XCTAssertEqual(stackView.arrangedSubviews[3], generator6.view)
        XCTAssertEqual(stackView.arrangedSubviews[4], generator7.view)
        XCTAssertEqual(stackView.arrangedSubviews[5], generator8.view)
    }

    func testUpdatingGenerators() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when

        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        generator2.title = "Updated Two"
        generator4.title = "Updated Four"
        ddm.update(generators: [generator2, generator4])
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews.count, generators.count)
        XCTAssertEqual((stackView.arrangedSubviews[1] as! UILabel).text, "Updated Two")
        XCTAssertEqual((stackView.arrangedSubviews[3] as! UILabel).text, "Updated Four")
    }

    func testForceRefill() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when

        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // then

        XCTAssertEqual(stackView.arrangedSubviews.count, generators.count)
    }

    func testClearing() {
        // given

        let generator1 = TitleStackCellGenerator(title: "One")
        let generator2 = TitleStackCellGenerator(title: "Two")
        let generator3 = TitleStackCellGenerator(title: "Three")
        let generator4 = TitleStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when

        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        ddm.clearCellGenerators()
        ddm.forceRefill()

        // then

        XCTAssert(stackView.arrangedSubviews.isEmpty)
    }
}
