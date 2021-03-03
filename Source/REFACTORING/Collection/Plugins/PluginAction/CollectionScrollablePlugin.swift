//
//  CollectionScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Plugin to orginise scrolling the collection.
public class CollectionScrollablePlugin: BaseCollectionPlugin<ScrollEvent> {

    // MARK: - Private Properties

    private let scrollProvider: CollectionScrollProvider

    // MARK: - Initialization

    /// - parameter scrollProvider: allows you to organize the scroll inside the collection
    ///
    /// For example that the beginning of a new element always appears on the left of the screen.
    init(scrollProvider: CollectionScrollProvider) {
        self.scrollProvider = scrollProvider
    }

    // MARK: - BaseCollectionPlugin

    public override func process(event: ScrollEvent, with manager: BaseCollectionManager?) {
        guard let view = manager?.view else { return }

        switch event {
        case .willBeginDragging:
            scrollProvider.setBeginDraggingOffset(view.contentOffset.x)
        case .willEndDragging(_, let targetContentOffset):
            scrollProvider.setTargetContentOffset(targetContentOffset, for: view)
        default:
            break
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to orginise scrolling the collection.
    ///
    /// - parameter scrollProvider: allows you to organize the scroll inside the collection
    ///
    /// For example that the beginning of a new element always appears on the left of the screen.
    static func scrollableBehaviour(scrollProvider: CollectionScrollProvider) -> CollectionScrollablePlugin {
        .init(scrollProvider: scrollProvider)
    }

}
