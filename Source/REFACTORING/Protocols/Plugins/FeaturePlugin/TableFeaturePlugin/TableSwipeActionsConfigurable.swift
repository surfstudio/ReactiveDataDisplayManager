//
//  TableSwipeActionsConfigurable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

@available(iOS 11.0, *)
public protocol TableSwipeActionsProvider {
    var isEnableSwipeActions: Bool { get set }

    func getLeadingSwipeActionsForGenerator(_ generator: RDDMSwipeableItem) -> TableSwipeActionsConfiguration?
    func getTrailingSwipeActionsForGenerator(_ generator: RDDMSwipeableItem) -> TableSwipeActionsConfiguration?
}

@available(iOS 11.0, *)
public protocol TableSwipeActionsConfigurable: TableFeaturePlugin {
    func leadingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration?
    func trailingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration?
}
