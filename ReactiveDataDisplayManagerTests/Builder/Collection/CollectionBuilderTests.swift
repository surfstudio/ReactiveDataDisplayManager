//
//  CollectionBuilderTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import XCTest
@testable import ReactiveDataDisplayManager

class CollectionBuilderTests: XCTestCase {

    private var collection: UICollectionView!

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
    }

    // MARK: - Initial Test

    func testThatBuilderReturningManagerAndContainsCollection() {
        // given
        let builder = collection.rddm.baseBuilder

        // when
        let ddm = builder.build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.isEmpty)
        XCTAssertTrue(builder.collectionPlugins.plugins.isEmpty)
        XCTAssertTrue(builder.prefetchPlugins.plugins.isEmpty)
        XCTAssertNil(builder.movablePlugin)

        XCTAssertTrue(ddm.view === collection)
        XCTAssertTrue(builder.manager === ddm)
    }

    // MARK: - Add Feature Plugin Test

    func testThatBuilderAddedMovablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: CollectionMovableItemPlugin = .movable()

        // when
        let ddm = builder.add(featurePlugin: plugin).build()

        // then
        XCTAssertNotNil(builder.movablePlugin)
        XCTAssertTrue(builder.movablePlugin === plugin)
        XCTAssertTrue(builder.manager === ddm)
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func testThatBuilderAddedDragAndDroppablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: CollectionDragAndDroppablePlugin = .dragAndDroppable()

        // when
        let ddm = builder.add(featurePlugin: plugin).build()

        // then
        XCTAssertNotNil(builder.dragAndDroppablePlugin)
        XCTAssertTrue(builder.dragAndDroppablePlugin === plugin)
        XCTAssertTrue(builder.manager === ddm)
    }
    #endif

    func testThatBuilderAddedTitleDisplayablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: CollectionItemTitleDisplayablePlugin = .sectionTitleDisplayable()

        // when
        let ddm = builder.add(featurePlugin: plugin).build()

        // then
        XCTAssertNotNil(builder.itemTitleDisplayablePlugin)
        XCTAssertTrue(builder.itemTitleDisplayablePlugin === plugin)
        XCTAssertTrue(builder.manager === ddm)
    }

    // MARK: - Add Collection Plugins Tests

    func testThatBuilderAddedFoldablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .foldable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.collectionPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedHighlightablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .highlightable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.collectionPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedSelectablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .selectable()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.collectionPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedSelectedItemScrollablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .scrollOnSelect(to: .top)

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.collectionPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    // MARK: - Add Scroll Plugins Tests

    #if os(iOS)
    func testThatBuilderAddedRefreshablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .refreshable(refreshControl: UIRefreshControl(), output: RefreshableOutputMock())

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }
    #endif

    func testThatBuilderAddedScrollViewDelegateProxyPlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .proxyScroll()

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedScrollablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .scrollableBehaviour(scrollProvider: CollectionScrollProviderMock())

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.scrollPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedPaginatablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .paginatable(progressView: ProgressViewMock(), output: PaginatableOutputMock())

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.collectionPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    // MARK: - Add Prefetch Plugins Test

    func testThatBuilderAddedPrefetchProxyPlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let plugin: BaseCollectionPlugin = .proxyPrefetch(to: .top)

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    func testThatBuilderAddedPrefetcherablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let prefetcher = PrefetcherStub()
        let plugin: CollectionPrefetcherablePlugin<PrefetcherStub, PrefetchableCollectionCellGeneratorMock> = .prefetch(prefetcher: prefetcher)

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
        XCTAssertTrue(builder.manager === ddm)
    }

    // MARK: - Set Delegate Test

    func testThatBuilderSetCustomDelegate() {
        // given
        let builder = collection.rddm.baseBuilder
        let delegate = CollectionDelegateStub()

        // when
        let ddm = builder
            .set(delegate: delegate)
            .build()

        // then
        XCTAssertNil(delegate.movablePlugin)
        XCTAssertTrue(delegate.scrollPlugins.plugins.isEmpty)
        XCTAssertTrue(delegate.collectionPlugins.plugins.isEmpty)
        XCTAssertTrue(delegate.builderConfigured)
        XCTAssertTrue(ddm.delegate === delegate)
    }

    func testThatBuilderSetCustomDataSource() {
        // given
        let builder = collection.rddm.baseBuilder
        let dataSource = CollectionDataSourceStub()
        let generator = CollectionCellGeneratorMock()

        // when
        let ddm = builder.set(dataSource: { manager in
            dataSource.provider = manager
            return dataSource
        }).build()

        for _ in 1...3 {
            ddm.addCellGenerator(generator)
        }

        // then
        XCTAssertTrue(dataSource === ddm.dataSource && dataSource === builder.dataSource)
        XCTAssertEqual(dataSource.provider?.generators[0].count, 3)
        XCTAssertTrue(dataSource.builderConfigured)
    }

    func testThatBuilderSetCustomAnimator() {
        // given
        let builder = collection.rddm.baseBuilder
        let animator = CollectionAnimatorStub()
        let generator = CollectionCellGeneratorMock()

        // when
        let ddm = builder.set(animator: animator).build()
        ddm.addCellGenerator(generator)
        ddm.update(generators: [generator])

        // then
        XCTAssertTrue(animator === builder.animator)
        XCTAssertTrue(animator.generatorsUpdated)
    }

}

#if os(tvOS)
extension CollectionBuilderTests {

    func testThatBuilderAddedFocusablePlugin() {
        // given
        let builder = collection.rddm.baseBuilder
        let focusablePlugin: CollectionFocusablePlugin = .focusable(by: .init())

        // when
        _ = builder.add(featurePlugin: focusablePlugin)
            .build()

        // then
        XCTAssertNotNil(builder.focusablePlugin)
        XCTAssertTrue(builder.focusablePlugin === focusablePlugin)
    }

}
#endif