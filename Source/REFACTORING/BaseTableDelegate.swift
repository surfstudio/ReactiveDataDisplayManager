//
//  BaseTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

// Base implementation for UITableViewDelegate protocol. Use it if NO special logic required.
open class BaseTableDelegate: NSObject, UITableViewDelegate {

    // MARK: - Properties

    weak var adapter: BaseTableAdapter?

    // MARK: - Public properties

    public var estimatedHeight: CGFloat = 40

    // MARK: - UITableViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let guardTable = self.adapter?.tableView else { return }
        self.adapter?.scrollEvent.invoke(with: guardTable)
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let generator = self.adapter?.stateManager.generators[safe: indexPath.section]?[safe: indexPath.row] else {
            return
        }
        self.adapter?.willDisplayCellEvent.invoke(with: (generator, indexPath))
        if let displayable = generator as? DisplayableFlow {
            displayable.willDisplayEvent.invoke(with: ())
        }
    }

    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let displayable = self.adapter?.stateManager.sections[safe: section] as? DisplayableFlow else {
            return
        }
        displayable.willDisplayEvent.invoke(with: ())
    }

    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let displayable = self.adapter?.stateManager.sections[safe: section] as? DisplayableFlow else {
            return
        }
        displayable.didEndDisplayEvent.invoke(with: ())
    }

    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let generator = self.adapter?.stateManager.generators[safe: indexPath.section]?[safe: indexPath.row] else {
            return
        }
        self.adapter?.didEndDisplayCellEvent.invoke(with: (generator, indexPath))
        if let displayable = generator as? DisplayableFlow {
            displayable.didEndDisplayEvent.invoke(with: ())
            displayable.didEndDisplayCellEvent?.invoke(with: cell)
        }
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let generator = self.adapter?.stateManager.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return false
    }

    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let generator = self.adapter?.stateManager.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return false
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let generator = self.adapter?.stateManager.generators[sourceIndexPath.section][sourceIndexPath.row] as? MovableGenerator,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else {
            return
        }

        guard let itemToMove = self.adapter?.stateManager.generators[sourceIndexPath.section][sourceIndexPath.row] else {
            return
        }

        // find oldSection and remove item from this array
        self.adapter?.stateManager.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        self.adapter?.stateManager.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

        self.adapter?.cellChangedPosition.invoke(with: (oldIndexPath: sourceIndexPath, newIndexPath: destinationIndexPath))

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
        return self.adapter?.stateManager.generators[indexPath.section][indexPath.row].cellHeight ?? 0
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.adapter?.stateManager.generators[indexPath.section][indexPath.row].estimatedCellHeight ?? estimatedHeight
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let adapter = self.adapter else {
            return nil
        }
        if section > adapter.stateManager.sections.count - 1 {
            return nil
        }
        return adapter.stateManager.sections[section].generate()
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let adapter = self.adapter else {
            return 0
        }
        // This code needed to avoid empty header
        if section > adapter.stateManager.sections.count - 1 {
            return 0.01
        }
        return adapter.stateManager.sections[section].height(tableView, forSection: section)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectable = self.adapter?.stateManager.generators[indexPath.section][indexPath.row] as? SelectableItem else { return }
        selectable.didSelectEvent.invoke(with: ())
        if selectable.isNeedDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.adapter?.scrollViewWillEndDraggingEvent.invoke(with: velocity)
    }

}
