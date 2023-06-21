//
//  TableSafeAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.05.2023.
//

import UIKit

/// UITableView Animator wrapper created to avoid crashing on empty operation in parallel with updates of data source
public final class TableSafeAnimator: Animator<UITableView> {

    private let baseAnimator: Animator<UITableView>
    private weak var generatorsProvider: TableGeneratorsProvider?

    public init(baseAnimator: Animator<UITableView>, generatorsProvider: TableGeneratorsProvider?) {
        self.baseAnimator = baseAnimator
        self.generatorsProvider = generatorsProvider
    }

    override func perform(in collection: UITableView, animated: Bool, operation: Animator<UITableView>.Operation?) {
        if operation == nil {
            let numberOfSectionsAreEqual = collection.numberOfSections == generatorsProvider?.sections.count
            guard numberOfSectionsAreEqual else {
                return
            }
            let numberOfCellsAreEqual = (0...(collection.numberOfSections - 1))
                .map { generatorsProvider?.generators[$0].count == collection.numberOfRows(inSection: $0) }
                .allSatisfy { $0 == true }

            guard numberOfCellsAreEqual else {
                return
            }
        }
        baseAnimator.perform(in: collection, animated: animated, operation: operation)
    }

}
