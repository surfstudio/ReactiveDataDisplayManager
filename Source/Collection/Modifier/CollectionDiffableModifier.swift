//
//  CollectionDiffableModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 16.03.2021.
//

import UIKit

/// Helper class to modify `UICollectionView` cells
///
/// - Note: Based on `UICollectionViewDiffableDataSource` and `NSDiffableDataSourceSnapshot` updating.
/// Animations selected automatically or ignored.
@available(iOS 13.0, tvOS 13.0, *)
class CollectionDiffableModifier: Modifier<UICollectionView, CollectionItemAnimation> {

    typealias CellGeneratorType = CollectionCellGenerator & DiffableItemSource
    typealias HeaderGeneratorType = CollectionHeaderGenerator & DiffableItemSource

    // MARK: - Properties

    private weak var provider: CollectionGeneratorsProvider?
    private weak var dataSource: DiffableCollectionDataSource?

    // MARK: - Init

    /// - parameter view: parent view
    /// - parameter provider: wrapped collection of sections and generators
    /// - parameter dataSource: `UICollectionViewDiffableDataSource` to apply new snapshots
    init(view: UICollectionView, provider: CollectionGeneratorsProvider, dataSource: DiffableCollectionDataSource) {
        super.init(view: view)
        self.provider = provider
        self.dataSource = dataSource
    }

    // MARK: - Methods

    /// Update snapshot
    override func reload() {
        let cellsIsEmpty = view?.visibleCells.isEmpty ?? true
        apply(animated: !cellsIsEmpty)
    }

    /// Reload items with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: CollectionItemAnimation) {
        apply(animated: updateAnimation != .none)
    }

    /// Reload items with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func reloadSections(at indexPaths: IndexSet, with updateAnimation: CollectionItemAnimation) {
        apply(animated: updateAnimation != .none)
    }

    /// Update snapshot after items replaced
    ///
    /// - parameter indexPath: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation: **ignored**,  see insertAnimation
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func replace(at indexPath: IndexPath, with removeAnimation: CollectionItemAnimation, and insertAnimation: CollectionItemAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Replace row at specified indexPath
    ///
    /// - parameters:
    ///     - indexPaths: indexPath: **ignored**, automatically calculated using `DiffableSnapshot`
    ///     - insertIndexPaths: indexPath: **ignored**, automatically calculated using `DiffableSnapshot`
    ///     - removeAnimation: **ignored**,  see insertAnimation
    ///     - insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    open override func replace(at indexPaths: [IndexPath],
                               on insertIndexPaths: [IndexPath],
                               with removeAnimation: CollectionItemAnimation,
                               and insertAnimation: CollectionItemAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Update snapshot after sections inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: CollectionItemAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Update snapshot after items inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: CollectionItemAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Remove items and section with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter section: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UICollectionViewDiffableDataSource`
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: CollectionItemAnimation) {
        apply(animated: removeAnimation != .none)
    }

}

// MARK: - Private

@available(iOS 13.0, tvOS 13.0, *)
private extension CollectionDiffableModifier {

    func apply(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let snapshot = makeSnapshot() else { return }

        safeApplySnapshot(snapshot, animated: animated, completion: completion)
    }

    func makeSnapshot() -> DiffableSnapshot? {
        guard let provider = provider else { return nil }

        assert(provider.generators is [[CellGeneratorType]], "This strategy support only \(CellGeneratorType.Type.self)")
        assert(provider.sections is [HeaderGeneratorType], "This strategy support only \(HeaderGeneratorType.Type.self)")

        guard
            let sections = provider.sections as? [HeaderGeneratorType],
            let generators = provider.generators as? [[CellGeneratorType]]
        else { return nil }

        var snapshot = DiffableSnapshot()

        for (index, section) in sections.enumerated() {
            snapshot.appendSections([section.diffableItem])

            guard let generators = generators[safe: index] else { continue }

            let items = generators.map { $0.diffableItem }
            snapshot.appendItems(items, toSection: section.diffableItem)
        }

        return snapshot
    }

    func safeApplySnapshot(_ snapshot: DiffableSnapshot, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let dataSource = dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

}
