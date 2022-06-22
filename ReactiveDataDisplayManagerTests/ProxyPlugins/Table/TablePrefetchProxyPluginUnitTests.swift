//
//  TablePrefetchProxyPluginUnitTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//

import XCTest
@testable import ReactiveDataDisplayManager

class TablePrefetchProxyPluginUnitTests: XCTestCase {

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
        let plugin = PrefetchPlugin()
        let ddm = builder.add(plugin: plugin).build()

        // when
        for id in 0...300 {
            ddm.addCellGenerator(CellGenerator(id: id))
        }
        ddm.forceRefill()
        ddm.scrollTo(generator: ddm.generators[0][100], scrollPosition: .top, animated: true)
        ddm.scrollTo(generator: ddm.generators[0][200], scrollPosition: .bottom, animated: true)
        ddm.scrollTo(generator: ddm.generators[0][50], scrollPosition: .top, animated: true)

        // then
        XCTAssertTrue(plugin.prefetchEventWasCalled)
    }

    // MARK: - Mock

    class PrefetchPlugin: TablePrefetchProxyPlugin {

        var prefetchEventWasCalled = false
        var cancelPrefetchingEventWasCalled = false

        func setSpyEvents() {
            prefetchEvent += { [weak self] _ in
                self?.prefetchEventWasCalled = true
            }
            cancelPrefetchingEvent += { [weak self] _ in
                self?.cancelPrefetchingEventWasCalled = true
            }
        }

    }

    class CellGenerator: TableCellGenerator, PrefetcherableItem {

        var requestId: Int?
        var identifier: String { String(describing: UITableViewCell.self) }

        init(id: Int) {
            requestId = id
        }

        func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

        func registerCell(in tableView: UITableView) {
            tableView.registerNib(identifier)
        }

    }

}
