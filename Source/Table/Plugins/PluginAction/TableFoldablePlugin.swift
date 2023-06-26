//
//  TableFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to support `FoldableItem`
///
/// Allow  expand or collapse child cells
public class TableFoldablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Nested types

    public typealias AnimationGroup = (remove: UITableView.RowAnimation, insert: UITableView.RowAnimation)

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? FoldableItem
            else {
                return
            }

            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager?.remove($0,
                                                                   with: .animated(foldable.animation.remove),
                                                                   needScrollAt: nil,
                                                                   needRemoveEmptySection: false)
                }
            } else {
                addCellGenerators(foldable.childGenerators, after: generator, with: manager)
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            updateIfNeeded(foldable.childGenerators, with: manager)
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableFoldablePlugin {

    func addCellGenerators(_ childGenerators: [TableCellGenerator],
                           after generator: TableCellGenerator,
                           with manager: BaseTableManager?) {
        if let manager = manager as? GravityTableManager {
            manager.addCellGenerators(childGenerators, after: generator)
        } else if let foldable = generator as? FoldableItem {
            manager?.insertManual(after: generator, new: childGenerators, with: .animated(foldable.animation.insert))
        } else {
            manager?.insertManual(after: generator, new: childGenerators, with: .notAnimated)
        }
    }

    func updateIfNeeded(_ childGenerators: [TableCellGenerator], with manager: BaseTableManager?) {
        guard let manager = manager as? GravityTableManager else { return }
        manager.update(generators: childGenerators)
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to support `FoldableItem`
    ///
    /// Allow  expand or collapse child cells
    static func foldable() -> TableFoldablePlugin {
        .init()
    }

}
