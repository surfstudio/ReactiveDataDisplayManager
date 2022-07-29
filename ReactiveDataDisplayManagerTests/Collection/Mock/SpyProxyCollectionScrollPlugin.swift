//
//  SpyProxyCollectionScrollPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

@testable import ReactiveDataDisplayManager

final class SpyProxyCollectionScrollPlugin: CollectionScrollViewDelegateProxyPlugin {

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
    }

}
