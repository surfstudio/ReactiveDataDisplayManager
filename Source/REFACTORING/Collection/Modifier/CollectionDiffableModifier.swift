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
@available(iOS 13, *)
class CollectionDiffableModifier: Modifier<UICollectionView, Bool> {

    typealias CellGeneratorType = CollectionCellGenerator & DiffableItemSource
    typealias HeaderGeneratorType = CollectionCellGenerator & DiffableItemSource

    // MARK: - Properties

    private weak var provider: TableGeneratorsProvider?
    private weak var dataSource: DiffableCollectionDataSource?

    // MARK: - Init

    /// - parameter view: parent view
    /// - parameter provider: wrapped collection of sections and generators
    /// - parameter dataSource: `UICollectionViewDiffableDataSource` to apply new snapshots
    init(view: UICollectionView, provider: TableGeneratorsProvider, dataSource: DiffableCollectionDataSource) {
        super.init(view: view)
        self.provider = provider
        self.dataSource = dataSource
    }

    // MARK: - Methods

    /// Update snapshot
    override func reload() {
        apply(animated: true)
    }

    /// Reload rows with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: Bool) {
        apply(animated: updateAnimation)
    }

    /// Reload rows with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func reloadScetions(at indexPaths: IndexSet, with updateAnimation: Bool) {
        apply(animated: updateAnimation)
    }

    /// Update snapshot after rows replaced
    ///
    /// - parameter indexPath: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation: **ignored**,  see insertAnimation
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func replace(at indexPath: IndexPath, with removeAnimation: Bool, and insertAnimation: Bool) {
        apply(animated: insertAnimation)
    }

    /// Update snapshot after sections inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: Bool) {
        apply(animated: insertAnimation)
    }

    /// Update snapshot after rows inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: Bool) {
        apply(animated: insertAnimation)
    }

    /// Remove rows and section with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter section: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: Bool) {
        apply(animated: removeAnimation)
    }

}

// MARK: - Private

@available(iOS 13, *)
private extension CollectionDiffableModifier {

    func apply(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let snapshot = makeSnapshot() else { return }

        safeApplySnapshot(snapshot, animated: animated, completion: completion)
    }

    func makeSnapshot() -> DiffableSnapshot? {
        guard let provider = provider else { return nil }

        assert(provider.generators is [[CellGeneratorType]], "This strategy support only \(CellGeneratorType.Type.self)")
        assert(provider.sections is [HeaderGeneratorType], "This strategy support only \(CellGeneratorType.Type.self)")

        guard
            let sections = provider.sections as? [HeaderGeneratorType],
            let generators = provider.generators as? [[CellGeneratorType]]
        else { return nil }

        var snapshot = DiffableSnapshot()

        for (index, section) in sections.enumerated() {
            snapshot.appendSections([section.item])

            guard let generators = generators[safe: index] else { continue }

            let items = generators.map { $0.item }
            snapshot.appendItems(items, toSection: section.item)
        }

        return snapshot
    }

    func safeApplySnapshot(_ snapshot: DiffableSnapshot, animated: Bool = false, completion: (() -> Void)? = nil) {

        DispatchQueue.main.async { [weak dataSource] in
            dataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
        }
    }

}
