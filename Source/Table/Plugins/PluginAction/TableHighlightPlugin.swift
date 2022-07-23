//
//  TableHighlightPlugin.swift
//  Pods
//
//  Created by porohov on 14.06.2022.
//

import UIKit

/// Plugin to support `HighlightableItem`
///
/// Provides the cell with update methods on selection, deselection, highlightion, unhighlightion
public class TableHighlightPlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Private Properties

    private let animationDuration: TimeInterval
    private let animationDelay: TimeInterval

    // MARK: - Initialization

    init(animationDuration: TimeInterval, animationDelay: TimeInterval) {
        self.animationDuration = animationDuration
        self.animationDelay = animationDelay
    }

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

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

            highlightable.applyUnhighlightedStyle()
        case .didSelect(let indexPath):
            guard let cell = manager?.view.cellForRow(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            highlightable.applySelectedStyle()
            animationDeselect(cell: highlightable, manager: manager, indexPath: indexPath)
        case .didDeselect(let indexPath):
            guard let cell = manager?.view.cellForRow(at: indexPath),
                  let highlightable = cell as? HighlightableItem else {
                      return
                  }

            highlightable.applyDeselectedStyle()
        default:
            break
        }
    }

    // MARK: - Private

    private func animationDeselect(cell: HighlightableItem, manager: BaseTableManager?, indexPath: IndexPath) {
        guard (manager?.generators[indexPath.section][indexPath.row] as? SelectableItem)?.isNeedDeselect == true else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: animationDelay) {
            cell.applyDeselectedStyle()
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to support `HighlightableItem`
    ///
    /// Handle `didHighlight` event by changing `contentView` style in the `HighlightableItem.applyHighlightedStyle`
    /// Handle `didUnhighlight` event by changing `contentView` style in the  `HighlightableItem.applyUnhighlightedStyle`
    /// Handle `didSelect` event by changing `contentView` style in the  `HighlightableItem.applySelectedStyle`
    /// Handle `didDeselect` event by changing `contentView` style in the  `HighlightableItem.applyDeselectedStyle`
    ///
    /// - Parameters:
    ///     - animationDuration: autodeselect cell animation duration, default value = 0.3
    ///     - animationDelay: autodeselect cell delay, default value = 0
    static func highlightable(animationDuration: TimeInterval = 0.3,
                              animationDelay: TimeInterval = .zero) -> BaseTablePlugin<TableEvent> {
        TableHighlightPlugin(animationDuration: animationDuration, animationDelay: animationDelay)
    }

}
