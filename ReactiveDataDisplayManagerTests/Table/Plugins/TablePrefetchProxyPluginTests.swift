//
//  TablePrefetchProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class TablePrefetchProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableView!
    private var ddm: BaseTableManager!
    private var proxyPlugin: SpyTablePrefetchPlugin!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        table = UITableView()
        proxyPlugin = .init()
        ddm = table.rddm.baseBuilder.add(plugin: proxyPlugin).build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        proxyPlugin = nil
        ddm = nil
    }

    // MARK: - Tests

    func testProxy_whenInitialState_thenEmptySpyState() {

        // then
        XCTAssertFalse(proxyPlugin.prefetchEventWasCalled)
        XCTAssertFalse(proxyPlugin.cancelPrefetchingEventWasCalled)
    }

    func testProxy_whenDataSource_prefetchRowsAtCalled_thenProxyEventCalled() {

        var indexPaths: [IndexPath]?
        proxyPlugin.prefetchEvent += { params in
            indexPaths = params
        }

        // given
        let row = Int.anyRandom()
        let section = Int.anyRandom()
        let expectedIndexPaths: [IndexPath] = [
            .init(row: row, section: section)
        ]

        // when
        table.prefetchDataSource?.tableView(table, prefetchRowsAt: expectedIndexPaths)

        // then
        XCTAssertTrue(proxyPlugin.prefetchEventWasCalled)
        XCTAssertEqual(indexPaths!, expectedIndexPaths)
    }

    func testProxy_whenDataSource_cancelPrefetchingCalled_thenProxyEventCalled() {

        var indexPaths: [IndexPath]?
        proxyPlugin.cancelPrefetchingEvent += { params in
            indexPaths = params
        }

        // given
        let row = Int.anyRandom()
        let section = Int.anyRandom()
        let expectedIndexPaths: [IndexPath] = [
            .init(row: row, section: section)
        ]

        // when
        table.prefetchDataSource?.tableView?(table, cancelPrefetchingForRowsAt: expectedIndexPaths)

        // then
        XCTAssertTrue(proxyPlugin.cancelPrefetchingEventWasCalled)
        XCTAssertEqual(indexPaths!, expectedIndexPaths)
    }

}
