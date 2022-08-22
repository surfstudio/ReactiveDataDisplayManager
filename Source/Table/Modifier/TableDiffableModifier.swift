//
//  TableDiffableModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

/// Helper class to modify `UITableView` cells
///
/// - Note: Based on `UITableViewDiffableDataSource` and `NSDiffableDataSourceSnapshot` updating.
/// Animations selected automatically or ignored.
@available(iOS 13.0, tvOS 13.0, *)
class TableDiffableModifier: Modifier<UITableView, UITableView.RowAnimation> {

    typealias GeneratorType = TableCellGenerator & DiffableItemSource
    typealias HeaderGeneratorType = TableHeaderGenerator & DiffableItemSource
    typealias FooterGeneratorType = TableFooterGenerator & DiffableItemSource

    // MARK: - Properties

    private weak var provider: TableSectionsProvider?
    private weak var dataSource: DiffableTableDataSource?

    // MARK: - Init

    /// - parameter view: parent view
    /// - parameter provider: wrapped collection of sections and generators
    /// - parameter dataSource: `UITableViewDiffableDataSource` to apply new snapshots
    init(view: UITableView, provider: TableSectionsProvider, dataSource: DiffableTableDataSource) {
        super.init(view: view)
        self.provider = provider
        self.dataSource = dataSource
    }

    // MARK: - Methods

    /// Update snapshot
    override func reload() {
        let cellsIsEmpty: Bool = view?.visibleCells.isEmpty ?? true
        apply(animated: !cellsIsEmpty)
    }

    /// Reload rows with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: UITableView.RowAnimation) {
        apply(animated: updateAnimation != .none)
    }

    /// Reload rows with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter updateAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func reloadSections(at indexPaths: IndexSet, with updateAnimation: UITableView.RowAnimation) {
        apply(animated: updateAnimation != .none)
    }

    /// Update snapshot after rows replaced
    ///
    /// - parameter indexPath: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation: **ignored**,  see insertAnimation
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func replace(at indexPath: IndexPath,
                          with removeAnimation: UITableView.RowAnimation,
                          and insertAnimation: UITableView.RowAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Update snapshot after rows replaced
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertIndexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation: **ignored**,  see insertAnimation
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    open override func replace(at indexPaths: [IndexPath],
                               on insertIndexPaths: [IndexPath],
                               with removeAnimation: UITableView.RowAnimation,
                               and insertAnimation: UITableView.RowAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Update snapshot after sections inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: UITableView.RowAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Update snapshot after rows inserted
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter insertAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: UITableView.RowAnimation) {
        apply(animated: insertAnimation != .none)
    }

    /// Remove rows and section with animation
    ///
    /// - parameter indexPaths: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter section: **ignored**, automatically calculated using `DiffableSnapshot`
    /// - parameter removeAnimation:
    ///     - **allowed** none to disable animation
    ///     - **ignored** any other, because automatically selected by `UITableDiffableDataSource`
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: UITableView.RowAnimation) {
        apply(animated: removeAnimation != .none)
    }

}

// MARK: - Private

@available(iOS 13.0, tvOS 13.0, *)
private extension TableDiffableModifier {

    func apply(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let snapshot = makeSnapshot() else { return }

        safeApplySnapshot(snapshot, animated: animated, completion: completion)
    }

    func makeSnapshot() -> DiffableSnapshot? {
        guard let provider = provider else { return nil }

        provider.sections.forEach { section in
            assert(section.generators is [GeneratorType], "This strategy support only \(GeneratorType.Type.self)")
            assert(section.header is HeaderGeneratorType, "This strategy support only \(HeaderGeneratorType.Type.self)")
            assert(section.footer is FooterGeneratorType, "This strategy support only \(FooterGeneratorType.Type.self)")
        }

        var snapshot = DiffableSnapshot()

        for section in provider.sections {
            guard
                let diffableSection = section.asDiffableItemSource(),
                let header = diffableSection.header?.diffableItem
            else { continue }

            snapshot.appendSections([header])
            snapshot.appendItems(diffableSection.generators.compactMap { $0.diffableItem }, toSection: header)
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
