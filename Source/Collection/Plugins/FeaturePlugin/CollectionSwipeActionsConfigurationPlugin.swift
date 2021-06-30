//
//  CollectionSwipeActionsConfigurationPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 19.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit
import Foundation

/// Use this plugin if you need to configure of `UISwipeActionsConfiguration`
@available(iOS 14.0, *)
public class CollectionSwipeActionsConfigurationPlugin: CollectionFeaturePlugin, CollectionSwipeActionsConfigurable {

    // MARK: - Properties

    public var swipeProvider: SwipeActionsProvider
    public weak var manager: BaseCollectionManager?

    // MARK: - Initialization

    /// - parameter swipeProvider: provider is responsible for configuring the `SwipeActionsConfiguration`
    public init(swipeProvider: SwipeActionsProvider) {
        self.swipeProvider = swipeProvider
    }

    // MARK: - CollectionSwipeActionsConfigurable

    /// This method allows you to add swipe actions to the `UICollectionLayoutListConfiguration` from your swipeProvider
    /// - parameter listConfiguration: `UICollectionLayoutListConfiguration` to which swipe actions will be added
    public func configureSwipeActions(for listConfiguration: inout UICollectionLayoutListConfiguration) {
        listConfiguration.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard
                let generator = self?.manager?.generators[indexPath.section][indexPath.row] as? SwipeableItem,
                let actions = self?.swipeProvider.getLeadingSwipeActionsForGenerator(generator)
            else { return nil }

            return self?.makeSwipeActionsConfiguration(for: generator, with: actions)
        }

        listConfiguration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard
                let generator = self?.manager?.generators[indexPath.section][indexPath.row] as? SwipeableItem,
                let actions = self?.swipeProvider.getTrailingSwipeActionsForGenerator(generator)
            else { return nil }

            return self?.makeSwipeActionsConfiguration(for: generator, with: actions)
        }
    }

}
#endif
