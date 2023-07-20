//
//  CollectionScrollViewDelegateProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Proxy of all `UIScrollViewDelegate` events
public class CollectionScrollViewDelegateProxyPlugin: BaseCollectionPlugin<ScrollEvent> {

    // MARK: - Properties

    public var didScroll = Event<UICollectionView>()
    public var willBeginDragging = Event<UICollectionView>()
    public var willEndDragging = Event<(collectionView: UICollectionView, velocity: CGPoint, targetContentOffset: CGPoint)>()
    public var didEndDragging = Event<(collectionView: UICollectionView, decelerate: Bool)>()
    public var didScrollToTop = Event<UICollectionView>()
    public var willBeginDecelerating = Event<UICollectionView>()
    public var didEndDecelerating = Event<UICollectionView>()
    public var willBeginZooming = Event<(collectionView: UICollectionView, view: UIView?)>()
    public var didEndZooming = Event<(collectionView: UICollectionView, view: UIView?, scale: CGFloat)>()
    public var didZoom = Event<UICollectionView>()
    public var didEndScrollingAnimation = Event<UICollectionView>()
    public var didChangeAdjustedContentInset = Event<UICollectionView>()

    // MARK: - BaseCollectionPlugin

    public override func process(event: ScrollEvent, with manager: BaseCollectionManager?) {
        guard let view = manager?.view else { return }

        switch event {
        case .didScroll:
            didScroll.invoke(with: view)
        case .willBeginDragging:
            willBeginDragging.invoke(with: view)
        case .willEndDragging(let velocity, let targetContentOffset):
            willEndDragging.invoke(with: (view, velocity, targetContentOffset.pointee))
        case .didEndDragging(let decelerate):
            didEndDragging.invoke(with: (view, decelerate))
        case .didScrollToTop:
            didScrollToTop.invoke(with: view)
        case .willBeginDecelerating:
            willBeginDecelerating.invoke(with: view)
        case .didEndDecelerating:
            didEndDecelerating.invoke(with: view)
        case .willBeginZooming(let zoomedView):
            willBeginZooming.invoke(with: (view, zoomedView))
        case .didEndZooming(let zoomedView, let scale):
            didEndZooming.invoke(with: (view, zoomedView, scale))
        case .didZoom:
            didZoom.invoke(with: view)
        case .didEndScrollingAnimation:
            didEndScrollingAnimation.invoke(with: view)
        case .didChangeAdjustedContentInset:
            didChangeAdjustedContentInset.invoke(with: view)
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to proxy of all `UIScrollViewDelegate` events
    static func proxyScroll() -> BaseCollectionPlugin<ScrollEvent> {
        CollectionScrollViewDelegateProxyPlugin()
    }

}

/// Proxy of  `CollectionScrollViewDelegateProxyPlugin` events
#if os(iOS)
@available(iOS 13.0, *)
public extension CollectionScrollViewDelegateProxyPlugin {

    // MARK: - Private static properties

    private static var didScrollCompositionLayoutSection = Event<ItemsInvalidationResult>()

    // MARK: Nested types

    struct ItemsInvalidationResult {
        public var items: [NSCollectionLayoutVisibleItem]
        public var offset: CGPoint
        public var environment: NSCollectionLayoutEnvironment

        public init(items: [NSCollectionLayoutVisibleItem],
                    offset: CGPoint,
                    environment: NSCollectionLayoutEnvironment) {
            self.items = items
            self.offset = offset
            self.environment = environment
        }
    }

    // MARK: - Ppublic properties

    /// - Note: To enable events you should link your `NSCollectionLayoutSection` with `CollectionScrollViewDelegateProxyPlugin` using method `NSCollectionLayoutSection.setHorizontalScroll`
    var didScrollCompositionLayoutSection: Event<ItemsInvalidationResult> {
        get {
            Self.didScrollCompositionLayoutSection
        }
        set {
            Self.didScrollCompositionLayoutSection = newValue
        }
    }

}

@available(iOS 13.0, *)
public extension NSCollectionLayoutSection {

    /// Set horizontal scroll type
    ///  - Parameters:
    ///   - type: Type of horizontal scroll
    ///   - plugin: Plugin `CollectionScrollViewDelegateProxyPlugin`
    func setHorizontalScroll(type: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                             with plugin: CollectionScrollViewDelegateProxyPlugin? = nil) {
        orthogonalScrollingBehavior = type
        visibleItemsInvalidationHandler = {
            let result = CollectionScrollViewDelegateProxyPlugin.ItemsInvalidationResult(items: $0, offset: $1, environment: $2)
            plugin?.didScrollCompositionLayoutSection.invoke(with: result)
        }
    }

}

// MARK: - CompositionLayout orthogonalScrollingBehavior animations

@available(iOS 13.0, *)
public extension CollectionScrollViewDelegateProxyPlugin.ItemsInvalidationResult {

    // MARK: - Private static properties

    private static let debouncer = Debouncer(queue: .global(qos: .userInitiated), delay: .milliseconds(100))
    private static var oldOffsetX: CGFloat?

    // MARK: - Nested types

    enum Aligment {
        case top, bottom, center
    }

    // MARK: - Public methods

    /// Apply scale to cells
    /// - Parameters:
    ///  - minScale: Minimum scale
    ///  - maxScale: Maximum scale
    ///  - aligment: Aligment of cells (top, bottom, center)
    func applyScale(minScale: CGFloat, maxScale: CGFloat, aligment: Aligment = .center) {
        // Remove header from cells
        let cellWithoutHeaderOrFooter = items.filter { $0.representedElementKind == .none }

        let contentWidth = environment.container.contentSize.width

        // Transform cells
        cellWithoutHeaderOrFooter.forEach { item in
            let height: CGFloat
            switch aligment {
            case .top:
                height = item.bounds.height / 2
            case .bottom:
                height = -(item.bounds.height / 2)
            case .center:
                height = .zero
            }
            let distanceFromCenter = abs(item.frame.midX - offset.x - contentWidth / 2.0)
            let scale = max(maxScale - distanceFromCenter / contentWidth, minScale)

            item.transform = CGAffineTransform(translationX: 0, y: -height)
                .scaledBy(x: scale, y: scale)
                .translatedBy(x: 0, y: height)
        }
    }

    /// Apply centred position to cells
    /// - Parameters:
    /// - collectionView: CollectionView. Need for scroll to item
    func applyCentredPosition(collectionView: UICollectionView?) {
        let velocity = collectionView?.panGestureRecognizer.velocity(in: collectionView)
        if velocity?.x != 0 {
            Self.debouncer.cancel()
        }
        let (_, indexPath) = getVisibleCenterItem()
        guard let indexPath = indexPath, Self.oldOffsetX != offset.x else {
            return
        }
        Self.oldOffsetX = offset.x
        Self.debouncer.run { [weak collectionView] in
            // waiting for main thread available
            DispatchQueue.main.async {
                collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }

}

// MARK: - Private methods

@available(iOS 13.0, *)
extension CollectionScrollViewDelegateProxyPlugin.ItemsInvalidationResult {

    private func getVisibleCenterItem() -> (NSCollectionLayoutVisibleItem?, IndexPath?) {
        // Step 1: Get the visible cells
        let visibleCells = items.filter { $0.representedElementKind == .none }

        // Step 2: Calculate the center point
        let contentWidth = environment.container.contentSize.width
        let contentHeight = environment.container.contentSize.height
        let centerX = contentWidth / 2
        let centerY = contentHeight / 2
        let centerPoint = CGPoint(x: centerX + offset.x,
                                  y: centerY + offset.y)

        // Step 3: Iterate through the visible cells to find the center most
        var minDistance: CGFloat = .greatestFiniteMagnitude
        var centerCell: NSCollectionLayoutVisibleItem?
        for cell in visibleCells {
            let cellCenter = cell.center
            let distance = hypot(centerPoint.x - cellCenter.x, centerPoint.y - cellCenter.y)
            if distance < minDistance {
                minDistance = distance
                centerCell = cell
            }
        }

        // Return the center cell and its indexPath
        return (centerCell, centerCell?.indexPath)
    }

}

#endif
