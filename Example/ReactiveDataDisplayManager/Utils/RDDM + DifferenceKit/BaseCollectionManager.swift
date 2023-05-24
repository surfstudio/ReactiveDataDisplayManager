//
//  BaseCollectionManager.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 14.04.2021.
//

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
        view.reload(using: changeset, interrupt: interrupt) { [weak self] _ in
            guard let registrator = self?.registrator, let view = self?.view else {
                return
            }
            self?.sections.registerAllIfNeeded(with: view, using: registrator)
        }
    }

}

// MARK: - Private Methods

private extension BaseCollectionManager {

    func makeSnapshot() -> [Section]? {
        return sections.compactMap { section -> Section? in
            guard
                let diffableSection = section.asDiffableItemSource(),
                let header = diffableSection.header?.diffableItem
            else { return nil }
            return Section(model: header, elements: diffableSection.generators.compactMap { $0.diffableItem })
        }
    }

}
