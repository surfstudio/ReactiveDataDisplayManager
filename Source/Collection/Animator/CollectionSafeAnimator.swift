//
//  CollectionSafeAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.05.2023.
//

import UIKit

/// UITableView Animator wrapper created to avoid crashing on empty operation in parallel with updates of data source
public class CollectionSafeAnimator: Animator<UICollectionView> {

    private let baseAnimator: Animator<UICollectionView>
    private weak var generatorsProvider: CollectionGeneratorsProvider?

    public init(baseAnimator: Animator<UICollectionView>, generatorsProvider: CollectionGeneratorsProvider?) {
        self.baseAnimator = baseAnimator
        self.generatorsProvider = generatorsProvider
    }

    public override func performAnimated(in collection: UICollectionView, operation: Operation?) {
        if (operation == nil) {
            let numberOfSectionsAreEqual = collection.numberOfSections == generatorsProvider?.sections.count
            guard numberOfSectionsAreEqual else {
                return
            }
            let numberOfCellsAreEqual = (0...(collection.numberOfSections - 1))
                .map { generatorsProvider?.generators[$0].count == collection.numberOfItems(inSection: $0) }
                .allSatisfy { $0 == true }

            guard numberOfCellsAreEqual else {
                return
            }
        }
        baseAnimator.performAnimated(in: collection, operation: operation)
    }

}
