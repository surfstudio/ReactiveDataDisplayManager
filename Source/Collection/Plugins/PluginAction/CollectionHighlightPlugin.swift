//
//  CollectionHighlightPlugin.swift
//  Library
//
//  Created by Никита Коробейников on 29.12.2021.
//

import UIKit

// MARK: - Item

public protocol HighlightableItem {

    var normalColor: UIColor { get }
    var highlightedColor: UIColor { get }

}

final class CollectionHighlightPlugin: BaseCollectionPlugin<CollectionEvent> {

    override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .didHighlight(let indexPath):
            guard let cell = manager?.view.cellForItem(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            cell.contentView.backgroundColor = highlightable.highlightedColor
        case .didUnhighlight(let indexPath):
            guard let cell = manager?.view.cellForItem(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            cell.contentView.backgroundColor = highlightable.normalColor
        default:
            break
        }

    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to support `HighlightableItem`
    ///
    /// Handle `didHighlight` event by changing `contentView` style to `HighlightableItem.highlightedStyle`
    /// Handle `didUnhighlight` event by changing `contentView` style to `HighlightableItem.normalStyle`
    static func highlightable() -> BaseCollectionPlugin<CollectionEvent> {
        CollectionHighlightPlugin()
    }

}
