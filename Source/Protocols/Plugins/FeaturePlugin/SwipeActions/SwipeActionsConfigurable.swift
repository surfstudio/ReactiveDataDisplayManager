//
//  SwipeActionsConfigurable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

#if os(iOS)
import UIKit

@available(iOS 11.0, *)
public protocol TableSwipeActionsConfigurable: TableFeaturePlugin, SwipeActionsConfigurable {
    func leadingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration?
    func trailingSwipeActionsConfigurationForRow(at indexPath: IndexPath, with manager: BaseTableManager?) -> UISwipeActionsConfiguration?
}

@available(iOS 14.0, *)
public protocol CollectionSwipeActionsConfigurable: CollectionFeaturePlugin, SwipeActionsConfigurable {
    var manager: BaseCollectionManager? { get set }
}

public protocol SwipeActionsConfigurable { }

@available(iOS 11.0, *)
public extension SwipeActionsConfigurable {

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
#endif
