// 
//  FocusablePlugin.swift
//  DifferenceKit
//
//  Created by Olesya Tranina on 06.07.2021.
//  
//

import UIKit
import Foundation

/// Plugin to focus cells
///
/// Allow focusing cells builded with `FocusableItem` generators
open class CollectionFocusablePlugin: CollectionFeaturePlugin, Focusable {

    // MARK: - Typealias

    public typealias Provider = CollectionGeneratorsProvider

    // MARK: - Properties

    open var delegate = FocusablePluginDelegate<Provider>()

    // MARK: - Initialization

    init(strategyFocusable: StrategyFocusable?) {
        delegate.strategyFocusable = strategyFocusable
    }

}

public extension CollectionFeaturePlugin {

    /// Plugin to focus cells
    ///
    /// Allow focusing cells builded with `FocusableItem` generators
    static func focusable(by: FocusStrategy? = nil) -> CollectionFocusablePlugin {
        .init(strategyFocusable: by)
    }

}

/// Plugin to focus cells
///
/// Allow focusing cells builded with `FocusableItem` generators
open class TableFocusablePlugin: TableFeaturePlugin, Focusable {

    // MARK: - Typealias

    public typealias Provider = TableGeneratorsProvider

    // MARK: - Properties

    open var delegate = FocusablePluginDelegate<Provider>()

    // MARK: - Initialization

    init(strategyFocusable: StrategyFocusable?) {
        delegate.strategyFocusable = strategyFocusable
    }

}

public extension TableFeaturePlugin {

    /// Plugin to focus cells
    ///
    /// Allow focusing cells builded with `FocusableItem` generators
    static func focusable(by: FocusStrategy? = nil) -> TableFocusablePlugin {
        .init(strategyFocusable: by)
    }

}
