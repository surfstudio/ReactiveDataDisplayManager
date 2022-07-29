//
//  CollectionScrollViewDelegateProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

// We are not testing UIScrollView behaviour. We are testing proxy between ddm and delegate only.
final class CollectionScrollViewDelegateProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var collection: UICollectionView!
    private var proxyPlugin: SpyProxyCollectionScrollPlugin!
    private var ddm: BaseCollectionManager!

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
        XCTAssertFalse(proxyPlugin.didScrollWasCalled)
        XCTAssertFalse(proxyPlugin.willBeginDraggingWasCalled)
        XCTAssertFalse(proxyPlugin.willEndDraggingWasCalled)
        XCTAssertFalse(proxyPlugin.didEndDraggingWasCalled)
        XCTAssertFalse(proxyPlugin.didScrollToTopWasCalled)
        XCTAssertFalse(proxyPlugin.willBeginDeceleratingWasCalled)
        XCTAssertFalse(proxyPlugin.didEndDeceleratingWasCalled)
        XCTAssertFalse(proxyPlugin.willBeginZoomingWasCalled)
        XCTAssertFalse(proxyPlugin.didEndZoomingWasCalled)
        XCTAssertFalse(proxyPlugin.didZoomWasCalled)
        XCTAssertFalse(proxyPlugin.didEndScrollingAnimationWasCalled)
    }

    func testProxy_whenScrollViewDidScroll_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidScroll?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didScrollWasCalled)
    }

    func testProxy_whenScrollViewWillBeginDragging_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewWillBeginDragging?(collection)

        // then
        XCTAssertTrue(proxyPlugin.willBeginDraggingWasCalled)
    }

    func testProxy_whenScrollViewWillEndDragging_thenPluginEventCalled() {

        var velocity: CGPoint?
        proxyPlugin.willEndDragging += { params in
            velocity = params.velocity
        }

        // given
        XCTAssertNil(velocity)
        let expectedVelocity = CGPoint(x: Double.anyRandom(), y: Double.anyRandom())
        var targetContentOffset: CGPoint = .zero

        // when
        collection.delegate?.scrollViewWillEndDragging?(collection,
                                                        withVelocity: expectedVelocity,
                                                        targetContentOffset: &targetContentOffset)

        // then
        XCTAssertTrue(proxyPlugin.willEndDraggingWasCalled)
        XCTAssertNotNil(velocity)
        XCTAssertEqual(velocity, expectedVelocity)
    }

    func testProxy_whenScrollViewDidEndDragging_thenPluginEventCalled() {

        var willDecelerate: Bool?
        proxyPlugin.didEndDragging += { params in
            willDecelerate = params.decelerate
        }

        // given
        XCTAssertNil(willDecelerate)

        // when
        collection.delegate?.scrollViewDidEndDragging?(collection, willDecelerate: true)

        // then
        XCTAssertTrue(proxyPlugin.didEndDraggingWasCalled)
        XCTAssertTrue(willDecelerate!)
    }

    func testProxy_whenScrollViewDidScrollToTop_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidScrollToTop?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didScrollToTopWasCalled)
    }

    func testProxy_whenScrollViewWillBeginDecelerating_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewWillBeginDecelerating?(collection)

        // then
        XCTAssertTrue(proxyPlugin.willBeginDeceleratingWasCalled)
    }

    func testProxy_whenScrollViewDidEndDecelerating_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidEndDecelerating?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didEndDeceleratingWasCalled)
    }

    func testProxy_whenScrollViewWillBeginZooming_thenPluginEventCalled() {

        var view: UIView?
        proxyPlugin.willBeginZooming += { params in
            view = params.view
        }

        // given
        XCTAssertNil(view)
        let expectedView = UIView()
        expectedView.tag = Int.anyRandom()

        // when
        collection.delegate?.scrollViewWillBeginZooming?(collection, with: expectedView)

        // then
        XCTAssertTrue(proxyPlugin.willBeginZoomingWasCalled)
        XCTAssertIdentical(view, expectedView)
    }

    func testProxy_whenScrollViewDidEndZooming_thenPluginEventCalled() {

        var view: UIView?
        var scale: CGFloat?
        proxyPlugin.didEndZooming += { params in
            view = params.view
            scale = params.scale
        }

        // given
        XCTAssertNil(view)
        XCTAssertNil(scale)
        let expectedView = UIView()
        expectedView.tag = Int.anyRandom()
        let expectedScale = CGFloat.anyRandom()

        // when
        collection.delegate?.scrollViewDidEndZooming?(collection, with: expectedView, atScale: expectedScale)

        // then
        XCTAssertTrue(proxyPlugin.didEndZoomingWasCalled)
        XCTAssertIdentical(view, expectedView)
        XCTAssertEqual(scale!, expectedScale)
    }

    func testProxy_whenScrollViewDidZoom_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidZoom?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didZoomWasCalled)
    }

    func testProxy_whenScrollViewDidEndScrollingAnimation_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidEndScrollingAnimation?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didEndScrollingAnimationWasCalled)
    }

    @available(iOS 11.0, *)
    func testProxy_whenScrollViewDidChangeAdjustedContentInset_thenPluginEventCalled() {

        // when
        collection.delegate?.scrollViewDidChangeAdjustedContentInset?(collection)

        // then
        XCTAssertTrue(proxyPlugin.didChangeAdjustedContentInsetWasCalled)
    }

}
