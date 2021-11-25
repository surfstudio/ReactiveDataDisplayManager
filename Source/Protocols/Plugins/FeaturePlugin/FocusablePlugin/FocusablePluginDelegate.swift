// 
//  FocusablePluginDelegate.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  

import Foundation
import UIKit

/// Delegate based on `FocusableDelegate` protocol.
open class FocusablePluginDelegate<Provider: GeneratorsProvider>: FocusableDelegate {

    // MARK: - Typealias

    public typealias GeneratorType = FocusableItem
    var strategyFocusable: StrategyFocusable?

    // MARK: - FocusableDelegate

    ///  Returns a boolean value whether to start focus or not
    ///  - Parameters:
    ///     - indexPath: IndexPath table or collection
    ///     - provider: Takes a collection or table manager
    public func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canBeFocused()
        }
        return false
    }

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collectionView: default value nil, needed to center the selected cell
    ///     - tableView: default value nil, needed to center the selected cell
    public func didFocusedCell(previusView: UIView?, nextView: UIView?,
                        indexPath: IndexPath?,
                        collectionView: UICollectionView? = nil,
                        tableView: UITableView? = nil) {
        strategyFocusable?.didFocused(previusView: previusView,
                                      nextView: nextView,
                                      indexPath: indexPath,
                                      collectionView: collectionView,
                                      tableView: tableView)
    }

}
