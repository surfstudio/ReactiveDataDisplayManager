//
//  TablePrefetchProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class TablePrefetchProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableView!
    private var builder: TableBuilder<BaseTableManager>!
    private var plugin: SpyTablePrefetchPlugin!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        // it's important to set size for tableView
        table = UITableView(frame: .init(x: .zero, y: .zero, width: 100, height: 500))
        plugin = .init()
        builder = table.rddm.baseBuilder
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        builder = nil
    }

    // MARK: - Tests

    func testThatBuilderAddedPlugin() {
        // given
        let plugin: TablePrefetchProxyPlugin = .proxyPrefetch()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.manager === ddm)
        XCTAssertFalse(builder.prefetchPlugins.plugins.isEmpty)
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
    }

    func testThatScrollCalledPrefetchPluginEvents() {
        // given

        let ddm = builder.add(plugin: plugin).build()

        let generators = Array(0...300).map { StubTableCellGenerator(model: "\($0)") }
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // when
        
        table.scrollToRow(at: .init(row: 200, section: 0), at: .bottom, animated: true)

        // then
        XCTAssertTrue(plugin.prefetchEventWasCalled)
    }

}
