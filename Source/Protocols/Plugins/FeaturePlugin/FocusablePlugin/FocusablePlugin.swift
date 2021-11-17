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

    init(model: FocusedPlaginModel?) {
        delegate.model = model
    }

}

public extension CollectionFeaturePlugin {

    /// Plugin to focus cells
    ///
    /// Allow focusing cells builded with `FocusableItem` generators
    static func focusable(model: FocusedPlaginModel? = nil) -> CollectionFocusablePlugin {
        .init(model: model)
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

    init(model: FocusedPlaginModel?) {
        delegate.model = model
    }

}

public extension TableFeaturePlugin {

    /// Plugin to focus cells
    ///
    /// Allow focusing cells builded with `FocusableItem` generators
    static func focusable(model: FocusedPlaginModel? = nil) -> TableFocusablePlugin {
        .init(model: model)
    }

}
