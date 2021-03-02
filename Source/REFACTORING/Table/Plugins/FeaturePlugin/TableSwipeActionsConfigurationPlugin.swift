//
//  TableSwipeActionsConfigurationPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Use this plugin if you need to configure of UISwipeActionsConfiguration
@available(iOS 11.0, *)
open class TableSwipeActionsConfigurationPlugin: TableSwipeActionsConfigurable {

    // MARK: - Private Properties

    private let swipeProvider: SwipeActionsProvider

    // MARK: - Initialization

    /// - parameter swipeProvider: provider is responsible for configuring the SwipeActionsConfiguration
    public init(swipeProvider: SwipeActionsProvider) {
        self.swipeProvider = swipeProvider
    }

    // MARK: - TableSwipeActionsConfigurable

    open func leadingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration? {
        guard
            let generator = manager?.generators[indexPath.section][indexPath.row] as? SwipeableItem,
            let actions = swipeProvider.getLeadingSwipeActionsForGenerator(generator)
        else { return nil }

        return makeSwipeActionsConfiguration(for: generator, with: actions)
    }

    open func trailingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration? {
        guard
            let generator = manager?.generators[indexPath.section][indexPath.row] as? SwipeableItem,
            let actions = swipeProvider.getTrailingSwipeActionsForGenerator(generator)
        else { return nil }

        return makeSwipeActionsConfiguration(for: generator, with: actions)
    }

}
