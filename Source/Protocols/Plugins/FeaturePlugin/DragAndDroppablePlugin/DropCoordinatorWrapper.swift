//
//  DropCoordinatorWrapper.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import Foundation
import UIKit

@available(iOS 11.0, *)
open class DropItemWrapper {

    public private(set) var dragItem: UIDragItem
    public private(set) var sourceIndexPath: IndexPath?

    public init(dragItem: UIDragItem, sourceIndexPath: IndexPath?) {
        self.dragItem = dragItem
        self.sourceIndexPath = sourceIndexPath
    }

}

/// Wrapper for UITableViewDropCoordinator or UICollectionViewDropCoordinator
@available(iOS 11.0, *)
open class DropCoordinatorWrapper<Coordinator: NSObjectProtocol> {

    public init() { }

    open var items: [DropItemWrapper] {
        preconditionFailure("\(#function) must be overriden in child")
    }

    open var session: UIDropSession {
        preconditionFailure("\(#function) must be overriden in child")
    }

    open var proposal: UIDropProposal {
        preconditionFailure("\(#function) must be overriden in child")
    }

    open var destinationIndexPath: IndexPath? {
        preconditionFailure("\(#function) must be overriden in child")
    }

    @discardableResult
    open func drop(_ dragItem: UIDragItem, toItemAt indexPath: IndexPath) -> UIDragAnimating {
        preconditionFailure("\(#function) must be overriden in child")
    }

}

@available(iOS 11.0, *)
open class TableDropCoordinatorWrapper: DropCoordinatorWrapper<UITableViewDropCoordinator> {

    private let coordinator: UITableViewDropCoordinator

    public init(coordinator: UITableViewDropCoordinator) {
        self.coordinator = coordinator
    }

    open override var items: [DropItemWrapper] {
        return coordinator.items.compactMap { DropItemWrapper(dragItem: $0.dragItem, sourceIndexPath: $0.sourceIndexPath) }
    }

    open override var session: UIDropSession {
        return coordinator.session
    }

    open override var proposal: UIDropProposal {
        return coordinator.proposal
    }

    open override var destinationIndexPath: IndexPath? {
        return coordinator.destinationIndexPath
    }

    @discardableResult
    open override func drop(_ dragItem: UIDragItem, toItemAt indexPath: IndexPath) -> UIDragAnimating {
        coordinator.drop(dragItem, toRowAt: indexPath)
    }

}

@available(iOS 11.0, *)
open class CollectionDropCoordinatorWrapper: DropCoordinatorWrapper<UICollectionViewDropCoordinator> {

    private let coordinator: UICollectionViewDropCoordinator

    public init(coordinator: UICollectionViewDropCoordinator) {
        self.coordinator = coordinator
    }

    open override var items: [DropItemWrapper] {
        return coordinator.items.compactMap { DropItemWrapper(dragItem: $0.dragItem, sourceIndexPath: $0.sourceIndexPath) }
    }

    open override var session: UIDropSession {
        return coordinator.session
    }

    open override var proposal: UIDropProposal {
        return coordinator.proposal
    }

    open override var destinationIndexPath: IndexPath? {
        return coordinator.destinationIndexPath
    }

    @discardableResult
    open override func drop(_ dragItem: UIDragItem, toItemAt indexPath: IndexPath) -> UIDragAnimating {
        coordinator.drop(dragItem, toItemAt: indexPath)
    }

}
#endif
