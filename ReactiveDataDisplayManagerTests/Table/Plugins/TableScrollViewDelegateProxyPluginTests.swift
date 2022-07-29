//
//  TableScrollViewDelegateProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class TableScrollViewDelegateProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableView!
    private var scrollPlugin: SpyProxyTableScrollPlugin!
    private var ddm: BaseTableManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        // it's important to set size for tableView
        table = UITableView(frame: .init(x: .zero, y: .zero, width: 100, height: 500))

        scrollPlugin = .init()
        ddm = table.rddm.baseBuilder.add(plugin: scrollPlugin).build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        scrollPlugin = nil
        ddm = nil
    }

    // MARK: - Tests

    func testThatScrollCalledDidScrollEvent() {

        // given
        let generators = Array(0...10).map { StubTableCellGenerator(model: "\($0)") }
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // when
        table.scrollToRow(at: .init(row: 3, section: 0), at: .top, animated: false)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
        XCTAssertTrue(scrollPlugin.didEndScrollingAnimationWasCalled)
    }

    func testThatAnimationScrollCalledDidScrollAndDidEndScrollingAnimationEvents() {
        // given
        let generators = Array(0...10).map { StubTableCellGenerator(model: "\($0)") }
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // when
        table.scrollToRow(at: .init(row: 3, section: 0), at: .top, animated: true)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
        XCTAssertTrue(scrollPlugin.didEndScrollingAnimationWasCalled)
    }

}
