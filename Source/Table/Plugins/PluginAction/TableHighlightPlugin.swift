//
//  TableHighlightPlugin.swift
//  Pods
//
//  Created by porohov on 14.06.2022.
//

import Foundation

final class TableHighlightPlugin: BaseTablePlugin<TableEvent> {

    override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .didHighlight(let indexPath):
            guard let cell = manager?.view.cellForRow(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            highlightable.applyHighlightedStyle()
        case .didUnhighlight(let indexPath):
            guard let cell = manager?.view.cellForRow(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            highlightable.applyNormalStyle()
        default:
            break
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to support `HighlightableItem`
    ///
    /// Handle `didHighlight` event by changing `contentView` style to `HighlightableItem.highlightedStyle`
    /// Handle `didUnhighlight` event by changing `contentView` style to `HighlightableItem.normalStyle`
    static func highlightable() -> BaseTablePlugin<TableEvent> {
        TableHighlightPlugin()
    }

}
