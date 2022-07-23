// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class TableBuilderTests: XCTestCase {

    private var table: UITableView!

    override func setUp() {
        super.setUp()
        table = UITableView()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
    }

    // MARK: - Initial Test

    func testThatBuilderReturningManagerAndContainsTable() {
        // given
        let builder = table.rddm.baseBuilder

        // when
        let ddm = builder.build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.isEmpty)
        XCTAssertTrue(builder.tablePlugins.plugins.isEmpty)
        XCTAssertTrue(builder.prefetchPlugins.plugins.isEmpty)
        XCTAssertNil(builder.swipeActionsPlugin)
        XCTAssertNil(builder.movablePlugin)

        XCTAssertIdentical(ddm.view, table)
        XCTAssertIdentical(builder.manager, ddm)
    }

    // MARK: - Add Feature Plugin Test

    func testThatBuilderAddedMovablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: TableMovableItemPlugin = .movable()

        // when
        let ddm = builder.add(featurePlugin: plugin).build()

        // then
        XCTAssertNotNil(builder.movablePlugin)
        XCTAssertIdentical(builder.movablePlugin, plugin)
        XCTAssertIdentical(builder.manager, ddm)
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func testThatBuilderAddedDragAndDroppablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: TableDragAndDroppablePlugin = .dragAndDroppable()

        // when
        let ddm = builder.add(featurePlugin: plugin).build()

        // then
        XCTAssertNotNil(builder.dragAndDroppablePlugin)
        XCTAssertIdentical(builder.dragAndDroppablePlugin, plugin)
        XCTAssertIdentical(builder.manager, ddm)
    }
    #endif

    // MARK: - Add Collection Plugins Tests

    func testThatBuilderAddedTitleDisplayablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: TableDisplayablePlugin = .displayable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.tablePlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    func testThatBuilderAddedFoldablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .foldable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.tablePlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    func testThatBuilderAddedHighlightablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .highlightable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.tablePlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    func testThatBuilderAddedSelectablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .selectable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.tablePlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    // MARK: - Add Scroll Plugins Tests

    #if os(iOS)
    func testThatBuilderAddedRefreshablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .refreshable(refreshControl: UIRefreshControl(), output: RefreshableOutputMock())

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }
    #endif

    func testThatBuilderAddedScrollViewDelegateProxyPlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .proxyScroll()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    func testThatBuilderAddedPaginatablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .paginatable(progressView: ProgressViewMock(), output: PaginatableOutputMock())

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.tablePlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    // MARK: - Add Prefetch Plugins Test

    func testThatBuilderAddedPrefetchProxyPlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let plugin: BaseTablePlugin = .proxyPrefetch()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    func testThatBuilderAddedPrefetcherablePlugin() {
        // given
        let builder = table.rddm.baseBuilder
        let prefetcher = PrefetcherStub()
        let plugin: TablePrefetcherablePlugin<PrefetcherStub, PrefetchableTableCellGeneratorMock> = .prefetch(prefetcher: prefetcher)

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertIdentical(builder.manager, ddm)
    }

    // MARK: - Set Delegate Test

    @available(iOS 11.0, *)
    func testThatBuilderSetCustomDelegate() {
        // given
        let builder = table.rddm.baseBuilder
        let delegate = TableDelegateStub()

        // when
        let ddm = builder
            .set(delegate: delegate)
            .build()

        // then
        #if os(iOS)
        XCTAssertNil(delegate.swipeActionsPlugin)
        #endif
        XCTAssertNil(delegate.movablePlugin)
        XCTAssertTrue(delegate.scrollPlugins.plugins.isEmpty)
        XCTAssertTrue(delegate.tablePlugins.plugins.isEmpty)

        XCTAssertTrue(delegate.builderConfigured)
        XCTAssertIdentical(ddm.delegate, delegate)
    }

    func testThatBuilderSetCustomDataSource() {
        // given
        let builder = table.rddm.baseBuilder
        let dataSource = TableDataSourceStub()
        let generator = TableCellGeneratorMock()

        // when
        let ddm = builder.set(dataSource: { manager in
            dataSource.provider = manager
            return dataSource
        }).build()

        for _ in 1...3 {
            ddm.addCellGenerator(generator)
        }

        // then
        XCTAssertIdentical(dataSource, ddm.dataSource)
        XCTAssertIdentical(dataSource, builder.dataSource)
        XCTAssertEqual(dataSource.provider?.generators[0].count, 3)
        XCTAssertTrue(dataSource.builderConfigured)
    }

    func testThatBuilderSetCustomAnimator() {
        // given
        let builder = table.rddm.baseBuilder
        let animator = TableAnimatorStub()
        let generator = TableCellGeneratorMock()

        // when
        let ddm = builder.set(animator: animator).build()
        ddm.addCellGenerator(generator)
        ddm.update(generators: [generator])

        // then
        XCTAssertIdentical(animator, builder.animator)
        XCTAssertTrue(animator.generatorsUpdated)
    }

}
