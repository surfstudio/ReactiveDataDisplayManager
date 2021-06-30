//
//  TableSwipeActionsConfigurationPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit

/// Plugin to configure `UISwipeActionsConfiguration`
@available(iOS 11.0, *)
open class TableSwipeActionsConfigurationPlugin: TableFeaturePlugin, TableSwipeActionsConfigurable {

    public typealias GeneratorType = SwipeableItem

    // MARK: - Private Properties

    private let swipeProvider: SwipeActionsProvider

    // MARK: - Public Methods

    /// - parameter swipeProvider: provider is responsible for configuring the `TableSwipeActionsConfiguration`
    init(swipeProvider: SwipeActionsProvider) {
        self.swipeProvider = swipeProvider
    }

    // MARK: - TableSectionTitleDisplayable

    open func leadingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration? {
        guard
            let generator = manager?.generators[indexPath.section][indexPath.row] as? GeneratorType,
            let actions = swipeProvider.getLeadingSwipeActionsForGenerator(generator)
        else { return nil }

        return makeSwipeActionsConfiguration(for: generator, with: actions)
    }

    open func trailingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration? {
        guard
            let generator = manager?.generators[indexPath.section][indexPath.row] as? GeneratorType,
            let actions = swipeProvider.getTrailingSwipeActionsForGenerator(generator)
        else { return nil }

        return makeSwipeActionsConfiguration(for: generator, with: actions)
    }

}

@available(iOS 11.0, *)
private extension TableSwipeActionsConfigurationPlugin {

    func makeSwipeActionsConfiguration(for generator: SwipeableItem,
                                       with swipeConfiguration: SwipeActionsConfiguration) -> UISwipeActionsConfiguration? {
        var generator = generator
        var actionTypes = [String]()

        let actions = swipeConfiguration.actions.map { action -> UIContextualAction in
            let contextualAction = UIContextualAction(style: action.style, title: action.title) { (_, _, completion) in
                generator.didSwipeEvent.invoke(with: action.type)
                completion(true)
            }

            if let backgroundColor = action.backgroundColor {
                contextualAction.backgroundColor = backgroundColor
            }

            if let image = action.image {
                contextualAction.image = image
            } else if let view = action.view {
                contextualAction.image = UIImage(view: view)
            }

            actionTypes.append(action.type)
            return contextualAction
        }

        generator.actionTypes = actionTypes

        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = swipeConfiguration.performsFirstActionWithFullSwipe

        return configuration
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to configure `UISwipeActionsConfiguration`
    ///
    /// - parameter swipeProvider: provider is responsible for configuring the `SwipeActionsConfiguration`
    @available(iOS 11.0, *)
    static func swipeActions(swipeProvider: SwipeActionsProvider) -> TableSwipeActionsConfigurationPlugin {
        .init(swipeProvider: swipeProvider)
    }

}
#endif
