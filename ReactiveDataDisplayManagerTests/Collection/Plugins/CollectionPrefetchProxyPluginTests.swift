//
//  CollectionPrefetchProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class CollectionPrefetchProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var ddm: BaseCollectionManager!
    private var proxyPlugin: SpyCollectionPrefetchProxyPlugin!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        proxyPlugin = .init()
        ddm = collection.rddm.baseBuilder.add(plugin: proxyPlugin).build()
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        proxyPlugin = nil
        ddm = nil
    }

    // MARK: - Tests

    func testProxy_whenInitialState_thenEmptySpyState() {

        // then
        XCTAssertFalse(proxyPlugin.prefetchEventWasCalled)
        XCTAssertFalse(proxyPlugin.cancelPrefetchingEventWasCalled)
    }

    func testProxy_whenDataSource_prefetchItemsAtCalled_thenProxyEventCalled() {

        var indexPaths: [IndexPath]?
        proxyPlugin.prefetchEvent += { params in
            indexPaths = params
        }

        // given
        let item = Int.anyRandom()
        let section = Int.anyRandom()
        let expectedIndexPaths: [IndexPath] = [
            .init(item: item, section: section)
        ]

        // when
        collection.prefetchDataSource?.collectionView(collection, prefetchItemsAt: expectedIndexPaths)

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
        let item = Int.anyRandom()
        let section = Int.anyRandom()
        let expectedIndexPaths: [IndexPath] = [
            .init(item: item, section: section)
        ]

        // when
        collection.prefetchDataSource?.collectionView?(collection, cancelPrefetchingForItemsAt: expectedIndexPaths)

        // then
        XCTAssertTrue(proxyPlugin.cancelPrefetchingEventWasCalled)
        XCTAssertEqual(indexPaths!, expectedIndexPaths)
    }

}
