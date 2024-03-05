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

    public typealias GeneratorType = FoldableItem & TableChildrenHolder & FoldableStateToggling

    // MARK: - Plugin body

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.sections[indexPath.section].generators[indexPath.row],
                let foldable = generator as? GeneratorType
            else {
                return
            }

            if foldable.isExpanded {
                foldable.children.forEach { manager?.remove($0,
                                                                   with: .animated(foldable.animation.remove),
                                                                   needScrollAt: nil,
                                                                   needRemoveEmptySection: false)
                }
            } else {
                addCellGenerators(foldable.children, after: generator, with: manager)
            }

            foldable.toggleEpanded()
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            updateIfNeeded(foldable.children, with: manager)
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableFoldablePlugin {

    func addCellGenerators(_ children: [TableCellGenerator],
                           after generator: TableCellGenerator,
                           with manager: BaseTableManager?) {
        if let manager = manager as? GravityTableManager {
            manager.addCellGenerators(children, after: generator)
        } else if let foldable = generator as? GeneratorType {
            manager?.insertManual(after: generator, new: children, with: .animated(foldable.animation.insert))
        } else {
            manager?.insertManual(after: generator, new: children, with: .notAnimated)
        }
    }

    func updateIfNeeded(_ children: [TableCellGenerator], with manager: BaseTableManager?) {
        guard let manager = manager as? GravityTableManager else { return }
        manager.update(generators: children)
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
