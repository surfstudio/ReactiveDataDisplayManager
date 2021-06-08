//
//  BaseCollectionManager.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 14.04.2021.
//
#if os(iOS)
import ReactiveDataDisplayManager
import DifferenceKit

extension BaseCollectionManager {

    // MARK: - Typealias

    typealias Section = ArraySection<DiffableItem, DiffableItem>
    typealias ChangesetClosure = (Changeset<[Section]>) -> Bool
    typealias ChangesClosure = (BaseCollectionManager) -> Void

    // MARK: - Internal Methods

    /// - parameters:
    ///   - changes: A staged set of changes.
    ///   - interrupt: A closure that takes an changeset as its argument and returns `true` if the animated
    ///                updates should be stopped and performed reloadData. Default is nil.
    func reload(with changes: ChangesClosure, interrupt: ChangesetClosure? = nil) {
        let oldSnapshot = makeSnapshot()

        changes(self)

        guard
            let source = oldSnapshot ?? makeSnapshot(),
            let data = makeSnapshot()
        else { return }

        let changeset = StagedChangeset(source: source, target: data)
        view.reload(using: changeset, interrupt: interrupt) { _ in }
    }

}

// MARK: - Private Methods

private extension BaseCollectionManager {

    func makeSnapshot() -> [Section]? {
        guard
            !sections.asDiffableItemSources.isEmpty,
            let generators = generators as? [[DiffableItemSource]]
        else { return nil }

        return sections.asDiffableItemSources.enumerated().compactMap { index, section -> Section? in
            let elements = generators.asDiffableItems[safe: index] ?? []
            return Section(model: section.item, elements: elements)
        }
    }

}
#endif
