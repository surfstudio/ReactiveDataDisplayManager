//
//  TableScrollViewDelegateProxyPluginUnitTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class TableScrollViewDelegateProxyPluginUnitTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableView!
    private var scrollPlugin: ProxyScrollPluginSpy!
    private var ddm: BaseTableManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        table = UITableView(frame: .init(x: .zero, y: .zero, width: 100, height: 500))
        scrollPlugin = .init()
        ddm = table.rddm.baseBuilder.add(plugin: scrollPlugin).build()
        scrollPlugin.setSpyEvents()
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
        let generator = CellGenerator()

        // when
        for _ in 0...10 { ddm.addCellGenerator(generator) }
        ddm.forceRefill()
        ddm.scrollTo(generator: ddm.generators[0][3], scrollPosition: .top, animated: false)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
    }

    func testThatAnimationScrollCalledDidScrollAndDidEndScrollingAnimationEvents() {
        // given
        let generator = CellGenerator()

        // when
        for _ in 0...10 { ddm.addCellGenerator(generator) }
        ddm.forceRefill()
        ddm.scrollTo(generator: ddm.generators[0][3], scrollPosition: .top, animated: true)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
        XCTAssertTrue(scrollPlugin.didEndScrollingAnimationWasCalled)
    }

    // MARK: - Mocks

    final class ProxyScrollPluginSpy: TableScrollViewDelegateProxyPlugin {

        var didScrollWasCalled = false
        var didEndScrollingAnimationWasCalled = false

        func setSpyEvents() {
            didScroll += { [weak self] _ in
                self?.didScrollWasCalled = true
            }
            didEndScrollingAnimation += { [weak self] _ in
                self?.didEndScrollingAnimationWasCalled = true
            }
        }

    }

    class CellGenerator: TableCellGenerator {

        var identifier: String {
            return String(describing: UITableViewCell.self)
        }

        func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

        func registerCell(in tableView: UITableView) {
            tableView.registerNib(identifier)
        }

    }

}
