//
//  CollectionScrollViewDelegateProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class CollectionScrollViewDelegateProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var scrollPlugin: SpyProxyCollectionScrollPlugin!
    private var ddm: BaseCollectionManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        // it's important to set size of colleciton and items
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 100, height: 40)
        collection = UICollectionView(frame: .init(x: .zero, y: .zero, width: 100, height: 500), collectionViewLayout: layout)
        collection.alwaysBounceVertical = true

        scrollPlugin = .init()
        ddm = collection.rddm.baseBuilder.add(plugin: scrollPlugin).build()
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
        scrollPlugin = nil
        ddm = nil
    }

    // MARK: - Tests

    func testThatScrollCalledDidScrollEvent() {
        // given
        let generators = Array(0...10).map { StubCollectionCell.rddm.baseGenerator(with: "\($0)", and: .class) }
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // when

        collection.scrollToItem(at: IndexPath(item: 3, section: 0), at: .top, animated: true)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
    }

    func testThatAnimationScrollCalledDidScrollAndDidEndScrollingAnimationEvents() {
        // given
        let generators = Array(0...10).map { StubCollectionCell.rddm.baseGenerator(with: "\($0)", and: .class) }
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        // when
        collection.scrollToItem(at: IndexPath(item: 3, section: 0), at: .top, animated: true)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
        XCTAssertTrue(scrollPlugin.didEndScrollingAnimationWasCalled)
    }

}
