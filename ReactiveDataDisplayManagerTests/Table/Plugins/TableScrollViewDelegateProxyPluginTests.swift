//
//  TableScrollViewDelegateProxyPluginTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 22.06.2022.
//
// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast discouraged_optional_boolean

import XCTest
@testable import ReactiveDataDisplayManager

final class TableScrollViewDelegateProxyPluginTests: XCTestCase {

    // MARK: - Properties

    private var table: UITableView!
    private var proxyPlugin: SpyProxyTableScrollPlugin!
    private var ddm: BaseTableManager!

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
        table.delegate?.scrollViewDidScroll?(table)

        // then
        XCTAssertTrue(proxyPlugin.didScrollWasCalled)
    }

    func testProxy_whenScrollViewWillBeginDragging_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewWillBeginDragging?(table)

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
        table.delegate?.scrollViewWillEndDragging?(table,
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
        table.delegate?.scrollViewDidEndDragging?(table, willDecelerate: true)

        // then
        XCTAssertTrue(proxyPlugin.didEndDraggingWasCalled)
        XCTAssertTrue(willDecelerate!)
    }

    func testProxy_whenScrollViewDidScrollToTop_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewDidScrollToTop?(table)

        // then
        XCTAssertTrue(proxyPlugin.didScrollToTopWasCalled)
    }

    func testProxy_whenScrollViewWillBeginDecelerating_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewWillBeginDecelerating?(table)

        // then
        XCTAssertTrue(proxyPlugin.willBeginDeceleratingWasCalled)
    }

    func testProxy_whenScrollViewDidEndDecelerating_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewDidEndDecelerating?(table)

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
        table.delegate?.scrollViewWillBeginZooming?(table, with: expectedView)

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
        table.delegate?.scrollViewDidEndZooming?(table, with: expectedView, atScale: expectedScale)

        // then
        XCTAssertTrue(proxyPlugin.didEndZoomingWasCalled)
        XCTAssertIdentical(view, expectedView)
        XCTAssertEqual(scale!, expectedScale)
    }

    func testProxy_whenScrollViewDidZoom_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewDidZoom?(table)

        // then
        XCTAssertTrue(proxyPlugin.didZoomWasCalled)
    }

    func testProxy_whenScrollViewDidEndScrollingAnimation_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewDidEndScrollingAnimation?(table)

        // then
        XCTAssertTrue(proxyPlugin.didEndScrollingAnimationWasCalled)
    }

    @available(iOS 11.0, *)
    func testProxy_whenScrollViewDidChangeAdjustedContentInset_thenPluginEventCalled() {

        // when
        table.delegate?.scrollViewDidChangeAdjustedContentInset?(table)

        // then
        XCTAssertTrue(proxyPlugin.didChangeAdjustedContentInsetWasCalled)
    }

}
