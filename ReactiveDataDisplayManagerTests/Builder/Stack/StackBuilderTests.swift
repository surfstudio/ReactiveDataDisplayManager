// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class StackBuilderTests: XCTestCase {

    private var stack: UIStackView!

    override func setUp() {
        super.setUp()
        stack = UIStackView()
    }

    override func tearDown() {
        super.tearDown()
        stack = nil
    }

    func testThatBuilderReturningManagerAndContainsStack() {
        // given
        let builder = stack.rddm.baseBuilder

        // when
        let ddm = builder.build()

        // then
        XCTAssertIdentical(ddm.view, stack)
        XCTAssertIdentical(builder.manager, ddm)
    }

}
