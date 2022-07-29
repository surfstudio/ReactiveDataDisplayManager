//
//  SpyProxyCollectionScrollPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

@testable import ReactiveDataDisplayManager

final class SpyProxyCollectionScrollPlugin: CollectionScrollViewDelegateProxyPlugin {

    private(set) var didScrollWasCalled = false
    private(set) var willBeginDraggingWasCalled = false
    private(set) var willEndDraggingWasCalled = false
    private(set) var didEndDraggingWasCalled = false
    private(set) var didScrollToTopWasCalled = false
    private(set) var willBeginDeceleratingWasCalled = false
    private(set) var didEndDeceleratingWasCalled = false
    private(set) var willBeginZoomingWasCalled = false
    private(set) var didEndZoomingWasCalled = false
    private(set) var didZoomWasCalled = false
    private(set) var didEndScrollingAnimationWasCalled = false
    private(set) var didChangeAdjustedContentInsetWasCalled = false

    override init() {
        super.init()
        setupEvents()
    }

    private func setupEvents() {
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
        didChangeAdjustedContentInset += { [weak self] _ in
            self?.didChangeAdjustedContentInsetWasCalled = true
        }
    }

}
