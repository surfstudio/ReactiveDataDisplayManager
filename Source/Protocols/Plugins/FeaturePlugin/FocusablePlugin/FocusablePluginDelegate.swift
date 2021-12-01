// 
//  FocusablePluginDelegate.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  

import Foundation
import UIKit

/// Delegate based on `FocusableDelegate` protocol.
open class FocusablePluginDelegate<Provider: GeneratorsProvider, CollectionType>: FocusableDelegate {

    // MARK: - Typealias

    public typealias GeneratorType = FocusableItem

    // MARK: - Internal Properties

    var strategyFocusable: FocusableStrategy<CollectionType>?

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
    ///     - previusView: previus view optional value
    ///     - nextView: next view optional value
    ///     - indexPath: IndexPath optional value
    ///     - collection: needed to center the selected cell, customize border for UITableView
    public func didUpdateFocus(previusView: UIView?,
                               nextView: UIView?,
                               indexPath: IndexPath?,
                               collection: CollectionType) {
        strategyFocusable?.didUpdateFocus(previusView: previusView,
                                          nextView: nextView,
                                          indexPath: indexPath,
                                          collection: collection)
    }

}
