//
//  StackBuilderTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

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
        XCTAssertTrue(ddm.view === stack)
        XCTAssertTrue(builder.manager === ddm)
    }

}
