//
//  BaseCollectionDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Base implementation for `UICollectionViewDelegate` protocol.
open class BaseCollectionDelegate: NSObject, CollectionDelegate {

    // MARK: - Typealias

    typealias CollectionAnimator = Animator<BaseCollectionManager.CollectionType>

    // MARK: - Properties

    weak public var manager: BaseCollectionManager? {
        didSet {
            collectionPlugins.setup(with: manager)
            scrollPlugins.setup(with: manager)
        }
    }

    public var collectionPlugins = PluginCollection<BaseCollectionPlugin<CollectionEvent>>()
    public var scrollPlugins = PluginCollection<BaseCollectionPlugin<ScrollEvent>>()
    public var movablePlugin: MovablePluginDelegate<CollectionGeneratorsProvider>?
    #if os(tvOS)
    public var focusablePlugin: FocusablePluginDelegate<CollectionGeneratorsProvider, UICollectionView>?
    #endif

    // MARK: - Private Properties

    private var animator: CollectionAnimator?

    private var _draggableDelegate: AnyObject?
    private var _droppableDelegate: AnyObject?

}

// MARK: - CollectionBuilderConfigurable

extension BaseCollectionDelegate {

    public func configure<T>(with builder: CollectionBuilder<T>) where T: BaseCollectionManager {
        animator = builder.animator

        movablePlugin = builder.movablePlugin?.delegate
        collectionPlugins = builder.collectionPlugins
        scrollPlugins = builder.scrollPlugins
        #if os(tvOS)
        focusablePlugin = builder.focusablePlugin?.delegate
        #endif

        #if os(iOS)
        if #available(iOS 11.0, *) {
            draggableDelegate = builder.dragAndDroppablePlugin?.draggableDelegate
            droppableDelegate = builder.dragAndDroppablePlugin?.droppableDelegate
        }
        #endif

        manager = builder.manager

        collectionPlugins.setup(with: manager)
        scrollPlugins.setup(with: manager)

    }

}

// MARK: - UICollectionViewDelegate

extension BaseCollectionDelegate {

    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .didHighlight(indexPath), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .didUnhighlight(indexPath), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .didSelect(indexPath), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .didDeselect(indexPath), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .willDisplayCell(indexPath, cell), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionPlugins.process(event: .didEndDisplayCell(indexPath, cell), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        #if os(iOS)
        return movablePlugin?.canFocusRow(at: indexPath, with: manager) ?? false
        #elseif os(tvOS)
        return focusablePlugin?.canFocusRow(at: indexPath, with: manager) ?? false
        #endif
    }

    open func collectionView(_ collectionView: UICollectionView,
                             didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                             with coordinator: UIFocusAnimationCoordinator) {
        #if os(tvOS)
        focusablePlugin?.didUpdateFocus(previusView: context.previouslyFocusedView,
                                        nextView: context.nextFocusedView,
                                        indexPath: context.nextFocusedIndexPath,
                                        collection: collectionView)
        #endif
    }

    open func collectionView(_ collectionView: UICollectionView,
                             willDisplaySupplementaryView view: UICollectionReusableView,
                             forElementKind elementKind: String, at indexPath: IndexPath) {
        collectionPlugins.process(event: .willDisplaySupplementaryView(indexPath, view, elementKind), with: manager)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             didEndDisplayingSupplementaryView view: UICollectionReusableView,
                             forElementOfKind elementKind: String, at indexPath: IndexPath) {
        collectionPlugins.process(event: .didEndDisplayingSupplementaryView(indexPath, view, elementKind), with: manager)
    }

}

#if os(iOS)

// MARK: - CollectionDragAndDropableDelegate

extension BaseCollectionDelegate: CollectionDragAndDropDelegate {

    @available(iOS 11.0, *)
    public var draggableDelegate: DraggablePluginDelegate<CollectionGeneratorsProvider>? {
        set { _draggableDelegate = newValue }
        get { _draggableDelegate as? DraggablePluginDelegate<CollectionGeneratorsProvider> }
    }

    @available(iOS 11.0, *)
    public var droppableDelegate: DroppablePluginDelegate<CollectionGeneratorsProvider, UICollectionViewDropCoordinator>? {
        set { _droppableDelegate = newValue }
        get { _droppableDelegate as? DroppablePluginDelegate<CollectionGeneratorsProvider, UICollectionViewDropCoordinator> }
    }

}

// MARK: - UICollectionViewDragDelegate

@available(iOS 11.0, *)
extension BaseCollectionDelegate {

    open func collectionView(_ collectionView: UICollectionView,
                             itemsForBeginning session: UIDragSession,
                             at indexPath: IndexPath) -> [UIDragItem] {
        return draggableDelegate?.makeDragItems(at: indexPath, with: manager) ?? []
    }

    open func collectionView(_ collectionView: UICollectionView,
                             dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return draggableDelegate?.draggableParameters?.parameters
    }

}

// MARK: - UICollectionViewDropDelegate

@available(iOS 11.0, *)
extension BaseCollectionDelegate {

    open func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        droppableDelegate?.performDrop(with: CollectionDropCoordinatorWrapper(coordinator: coordinator),
                                       and: manager,
                                       view: collectionView,
                                       modifier: manager?.dataSource?.modifier)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             dropSessionDidUpdate session: UIDropSession,
                             withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let operation = droppableDelegate?.didUpdateItem(with: destinationIndexPath, in: collectionView) else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        return UICollectionViewDropProposal(operation: operation)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return droppableDelegate?.droppableParameters
    }

}
#endif

// MARK: AccessibilityItemDelegate

extension BaseCollectionDelegate: AccessibilityItemDelegate {

    public func didInvalidateAccessibility(for item: AccessibilityItem, of kind: AccessibilityItemKind) {
        switch kind {
        case .header(let section):
            collectionPlugins.process(event: .invalidatedHeaderAccessibility(section, item), with: manager)
        case .cell(let indexPath):
            collectionPlugins.process(event: .invalidatedCellAccessibility(indexPath, item), with: manager)
        case .footer(let section):
            collectionPlugins.process(event: .invalidatedFooterAccessibility(section, item), with: manager)
        }
    }

}

// MARK: UIScrollViewDelegate

extension BaseCollectionDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didScroll, with: manager)
    }

    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didScrollToTop, with: manager)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .willBeginDragging, with: manager)
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                        withVelocity velocity: CGPoint,
                                        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollPlugins.process(event: .willEndDragging(velocity: velocity,
                                                      targetContentOffset: targetContentOffset), with: manager)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollPlugins.process(event: .didEndDragging(decelerate), with: manager)
    }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .willBeginDecelerating, with: manager)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didEndDecelerating, with: manager)
    }

    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollPlugins.process(event: .willBeginZooming(view), with: manager)
    }

    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollPlugins.process(event: .didEndZooming(view: view, scale: scale), with: manager)
    }

    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didZoom, with: manager)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didEndScrollingAnimation, with: manager)
    }

    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollPlugins.process(event: .didChangeAdjustedContentInset, with: manager)
    }

}
