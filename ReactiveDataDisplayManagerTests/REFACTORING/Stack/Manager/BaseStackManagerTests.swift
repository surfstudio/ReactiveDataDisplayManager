// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseStackManagerTests: XCTestCase {

    private var ddm: BaseStackManager!
    private var stackView: UIStackView!

    override func setUp() {
        super.setUp()
        stackView = UIStackView()
        ddm = stackView.rddm.baseBuilder.build()
    }

    override func tearDown() {
        super.tearDown()
        stackView = nil
        ddm = nil
    }

    // MARK: - Initialization tests
    
    func testThatObjectPropertiesInitializeCorrectly() {
        // when
        let ddm = BaseStackManager()
        // then
        XCTAssertTrue(ddm.cellGenerators.isEmpty)
    }

    // MARK: - Generator actions tests

    func testAddingOneGenerator() {
        // given
        let generator1 = MockStackCellGenerator(title: "One")

        // when
        ddm.addCellGenerator(generator1)
        ddm.forceRefill()

        // then
        XCTAssertEqual(stackView.arrangedSubviews.count, 1)
    }

    func testAddingMultipleGenerators() {
        // given
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // then
        XCTAssertEqual(stackView.arrangedSubviews.count, generators.count)
    }

    func testAddingOneGeneratorAfterAnotherGenerators() {
        // given
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]
        let generator5 = MockStackCellGenerator(title: "After Two")

        // when
        ddm.addCellGenerators(generators)
        ddm.addCellGenerator(generator5, after: generator2)
        ddm.forceRefill()

        // then
        XCTAssertEqual(stackView.arrangedSubviews[2], generator5.view)
    }

    func testAddingMultipleGeneratorAfterAnotherGenerators() {
        // given
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]
        let generator5 = MockStackCellGenerator(title: "After Two")
        let generator6 = MockStackCellGenerator(title: "After Two")
        let generator7 = MockStackCellGenerator(title: "After Two")
        let generator8 = MockStackCellGenerator(title: "After Two")
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
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
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
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // then
        XCTAssertEqual(stackView.arrangedSubviews.count, generators.count)
    }

    func testClearing() {
        // given
        let generator1 = MockStackCellGenerator(title: "One")
        let generator2 = MockStackCellGenerator(title: "Two")
        let generator3 = MockStackCellGenerator(title: "Three")
        let generator4 = MockStackCellGenerator(title: "Four")
        let generators = [generator1, generator2, generator3, generator4]

        // when
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        ddm.clearCellGenerators()
        ddm.forceRefill()

        // then
        XCTAssertEqual(stackView.arrangedSubviews.count, 0)
    }

}

// MARK: - Mocks

fileprivate final class MockStackCellGenerator: StackCellGenerator {

    var title: String
    var view: UIView?

    init(title: String) {
        self.title = title
    }

}

// MARK: - StackCellGenerator

extension MockStackCellGenerator: ViewBuilder {

    func build(view: UILabel) {
        self.view = view
        view.text = title
        view.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }

}
