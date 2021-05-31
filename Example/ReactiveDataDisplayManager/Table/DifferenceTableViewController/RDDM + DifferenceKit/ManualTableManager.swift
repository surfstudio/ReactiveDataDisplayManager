//
//  ManualTableManager.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import DifferenceKit

extension ManualTableManager {

    typealias Section = ArraySection<TableHeaderGenerator, DifferentiableItem>

    func reload(with oldDifferentiableSections: [Section]?, animation: @autoclosure () -> UITableView.RowAnimation = .automatic) {
        guard
            let oldDifferentiableSections = oldDifferentiableSections ?? makeDifferentiableSections(),
            let data = makeDifferentiableSections()
        else { return }

        let changeset = StagedChangeset(source: oldDifferentiableSections, target: data)

        view.reload(using: changeset, with: animation()) { _ in }
    }

    func reload(with oldDifferentiableSections: [Section]?,
                deleteSectionsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                insertSectionsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                reloadSectionsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                deleteRowsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                insertRowsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                reloadRowsAnimation: @autoclosure () -> UITableView.RowAnimation = .automatic,
                interrupt: ((Changeset<[Section]>) -> Bool)? = nil) {
        guard
            let oldDifferentiableSections = oldDifferentiableSections ?? makeDifferentiableSections(),
            let data = makeDifferentiableSections()
        else { return }

        let changeset = StagedChangeset(source: oldDifferentiableSections, target: data)
        view.reload(using: changeset,
                    deleteSectionsAnimation: deleteSectionsAnimation(),
                    insertSectionsAnimation: insertSectionsAnimation(),
                    reloadSectionsAnimation: reloadSectionsAnimation(),
                    deleteRowsAnimation: deleteRowsAnimation(),
                    insertRowsAnimation: insertRowsAnimation(),
                    reloadRowsAnimation: reloadRowsAnimation(),
                    interrupt: interrupt) { _ in }
    }

    func makeDifferentiableSections() -> [Section]? {
        guard let generators = generators as? [[RDDMDifferentiable]] else { return nil }

        let data = sections.enumerated().map { index, section -> Section in
            let differentiableItems = generators[index].compactMap { $0.differentiableItem }
            return Section(model: section, elements: differentiableItems)
        }

        return data
    }

}
