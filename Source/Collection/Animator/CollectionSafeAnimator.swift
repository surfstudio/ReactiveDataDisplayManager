//
//  CollectionSafeAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.05.2023.
//

import UIKit

/// UICollectionView Animator wrapper created to avoid crashing on empty operation in parallel with updates of data source
public final class CollectionSafeAnimator: Animator<UICollectionView> {

    private let baseAnimator: Animator<UICollectionView>
    private weak var sectionsProvider: CollectionSectionsProvider?

    public init(baseAnimator: Animator<UICollectionView>, sectionsProvider: CollectionSectionsProvider?) {
        self.baseAnimator = baseAnimator
        self.sectionsProvider = sectionsProvider
    }

    override func perform(in collection: UICollectionView, animated: Bool, operation: Animator<UICollectionView>.Operation?) {
        if operation == nil {
            let numberOfSectionsAreEqual = collection.numberOfSections == sectionsProvider?.sections.count
            guard numberOfSectionsAreEqual else {
                return
            }
            let numberOfCellsAreEqual = (0..<collection.numberOfSections)
                .map { sectionsProvider?.sections[safe: $0]?.generators.count == collection.numberOfItems(inSection: $0) }
                .allSatisfy { $0 == true }

            guard numberOfCellsAreEqual else {
                return
            }
        }
        baseAnimator.perform(in: collection, animated: animated, operation: operation)
    }

}
