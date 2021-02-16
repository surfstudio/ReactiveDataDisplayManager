//
//  CollectionSelectedItemScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Adds support scrolling to selected item
public class CollectionSelectedItemScrollablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - Private Properties

    private let scrollPosition: UICollectionView.ScrollPosition

    // MARK: - Initialization

    /// - parameter scrollPosition: an option that specifies where the item should be positioned when scrolling finishes.
    public init(scrollPosition: UICollectionView.ScrollPosition) {
        self.scrollPosition = scrollPosition
    }

    // MARK: - BaseCollectionPlugin

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {
        switch event {
        case .didSelect(let indexPath):
            manager?.view?.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        default:
            break
        }
    }

}
