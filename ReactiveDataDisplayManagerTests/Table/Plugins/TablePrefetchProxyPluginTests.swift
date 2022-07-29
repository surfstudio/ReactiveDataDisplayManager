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

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        table = UITableView()
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
        let plugin = SpyPrefetchPlugin()
        let ddm = builder.add(plugin: plugin).build()

        for id in 0...300 {
            ddm.addCellGenerator(StubTableCellGenerator(model: "\(id)"))
        }
        ddm.forceRefill()

        // when
        
        table.scrollToRow(at: .init(row: 300, section: 0), at: .bottom, animated: true)

        // then
        XCTAssertTrue(plugin.prefetchEventWasCalled)
    }

}
