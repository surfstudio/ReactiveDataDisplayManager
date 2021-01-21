//
//  BaseTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

public protocol TableStateManager: AbstractStateManager {
    func remove(_ generator: CellGeneratorType,
                              with animation: UITableView.RowAnimation,
                              needScrollAt scrollPosition: UITableView.ScrollPosition?,
                              needRemoveEmptySection: Bool)
}

public protocol TableAdapter: AnyObject {
    var tableView: UITableView { get }
    var scrollEvent: BaseEvent<UITableView> { get set }
    var scrollViewWillEndDraggingEvent: BaseEvent<CGPoint> { get set }
    var cellChangedPosition: BaseEvent<(oldIndexPath: IndexPath, newIndexPath: IndexPath)> { get set }

    /// Celled when cells displaying
    var willDisplayCellEvent: BaseEvent<(TableCellGenerator, IndexPath)> { get set }
    var didEndDisplayCellEvent: BaseEvent<(TableCellGenerator, IndexPath)> { get set }
}

// Base implementation for UITableViewDelegate protocol. Use it if NO special logic required.
open class BaseTableDelegate: NSObject, UITableViewDelegate {

    // MARK: - Properties

    var stateManager: BaseTableStateManager

    var plugins = PluginCollection<TableEvent, BaseTableStateManager>()

    init(stateManager: BaseTableStateManager) {
        self.stateManager = stateManager
    }

    // MARK: - Public properties

    public var estimatedHeight: CGFloat = 40

    // MARK: - UITableViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: - broadcast event through plugins
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        plugins.process(event: .willDisplayCell(indexPath), with: stateManager)
    }

    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        plugins.process(event: .willDisplayHeader(section), with: stateManager)
    }

    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        plugins.process(event: .didEndDisplayHeader(section), with: stateManager)
    }

    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        plugins.process(event: .didEndDisplayCell(indexPath), with: stateManager)
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let generator = self.stateManager.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return false
    }

    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let generator = self.stateManager.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return false
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let generator = self.stateManager.generators[sourceIndexPath.section][sourceIndexPath.row] as? MovableGenerator,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else {
            return
        }

        let itemToMove = self.stateManager.generators[sourceIndexPath.section][sourceIndexPath.row]

        // find oldSection and remove item from this array
        self.stateManager.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        self.stateManager.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

        // need to prevent crash with internal inconsistency of UITableView
        DispatchQueue.main.async {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.stateManager.generators[indexPath.section][indexPath.row].cellHeight
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.stateManager.generators[indexPath.section][indexPath.row].estimatedCellHeight ?? estimatedHeight
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > stateManager.sections.count - 1 {
            return nil
        }
        return stateManager.sections[section].generate()
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // This code needed to avoid empty header
        if section > stateManager.sections.count - 1 {
            return 0.01
        }
        return stateManager.sections[section].height(tableView, forSection: section)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        plugins.process(event: .didSelect(indexPath), with: stateManager)
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO: - broadcast event through plugin
    }

}
