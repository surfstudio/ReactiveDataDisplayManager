//
//  CollectionPrefetchProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class CollectionPrefetchProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var builder: CollectionBuilder<BaseCollectionManager>!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        builder = collection.rddm.baseBuilder
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        builder = nil
    }

    // MARK: - Tests

    func testThatBuilderAddedPlugin() {
        // given
        let plugin: CollectionPrefetchProxyPlugin = .proxyPrefetch(to: .top)

        // when
        let ddm = builder.add(plugin: plugin).build()

        // then
        XCTAssertTrue(builder.manager === ddm)
        XCTAssertFalse(builder.prefetchPlugins.plugins.isEmpty)
        XCTAssertTrue(builder.prefetchPlugins.plugins.contains(where: { $0.pluginName == plugin.pluginName }))
    }

}
