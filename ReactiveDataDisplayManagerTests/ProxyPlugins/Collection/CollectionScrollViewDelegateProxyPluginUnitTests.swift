//
//  CollectionScrollViewDelegateProxyPluginUnitTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

class CollectionScrollViewDelegateProxyPluginUnitTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var scrollPlugin: ProxyScrollPluginSpy!
    private var ddm: BaseCollectionManager!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 100, height: 40)
        collection = UICollectionView(frame: .init(x: .zero, y: .zero, width: 100, height: 500), collectionViewLayout: layout)
        collection.alwaysBounceVertical = true
        scrollPlugin = .init()
        ddm = collection.rddm.baseBuilder.add(plugin: scrollPlugin).build()
        scrollPlugin.setSpyEvents()
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
        let generator = CellGenerator()
        let scrollToIndex = IndexPath(item: 3, section: 0)

        // when
        for _ in 0...10 { ddm.addCellGenerator(generator) }
        ddm.view.scrollToItem(at: scrollToIndex, at: .top, animated: false)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
    }

    func testThatAnimationScrollCalledDidScrollAndDidEndScrollingAnimationEvents() {
        // given
        let generator = CellGenerator()
        let scrollToIndex = IndexPath(item: 3, section: 0)

        // when
        for _ in 0...10 { ddm.addCellGenerator(generator) }
        ddm.view.scrollToItem(at: scrollToIndex, at: .top, animated: true)

        // then
        XCTAssertTrue(scrollPlugin.didScrollWasCalled)
        XCTAssertTrue(scrollPlugin.didEndScrollingAnimationWasCalled)
    }

    // MARK: - Mocks

    final class ProxyScrollPluginSpy: CollectionScrollViewDelegateProxyPlugin {

        var didScrollWasCalled = false
        var willBeginDraggingWasCalled = false
        var willEndDraggingWasCalled = false
        var didEndDraggingWasCalled = false
        var didScrollToTopWasCalled = false
        var willBeginDeceleratingWasCalled = false
        var didEndDeceleratingWasCalled = false
        var willBeginZoomingWasCalled = false
        var didEndZoomingWasCalled = false
        var didZoomWasCalled = false
        var didEndScrollingAnimationWasCalled = false

        func setSpyEvents() {
            didScroll += { [weak self] _ in
                self?.didScrollWasCalled = true
            }
            willBeginDragging += { [weak self] _ in
                self?.willBeginDraggingWasCalled = true
            }
            willEndDragging += { [weak self] _ in
                self?.willEndDraggingWasCalled = true
            }
            didEndDragging += { [weak self] _ in
                self?.didEndDraggingWasCalled = true
            }
            didScrollToTop += { [weak self] _ in
                self?.didScrollToTopWasCalled = true
            }
            willBeginDecelerating += { [weak self] _ in
                self?.willBeginDeceleratingWasCalled = true
            }
            didEndDecelerating += { [weak self] _ in
                self?.didEndDeceleratingWasCalled = true
            }
            willBeginZooming += { [weak self] _ in
                self?.willBeginZoomingWasCalled = true
            }
            didEndZooming += { [weak self] _ in
                self?.didEndZoomingWasCalled = true
            }
            didZoom += { [weak self] _ in
                self?.didZoomWasCalled = true
            }
            didEndScrollingAnimation += { [weak self] _ in
                self?.didEndScrollingAnimationWasCalled = true
            }
        }

    }

    class CellGenerator: CollectionCellGenerator {

        var identifier: String {
            return String(describing: UICollectionViewCell.self)
        }

        func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell(frame: .init(x: 0, y: 0, width: 100, height: 40))
        }

        func registerCell(in collectionView: UICollectionView) {
            collectionView.registerNib(identifier)
        }

    }

}
