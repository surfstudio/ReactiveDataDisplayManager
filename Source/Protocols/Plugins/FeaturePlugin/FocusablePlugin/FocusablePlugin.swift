// 
//  FocusablePlugin.swift
//  DifferenceKit
//
//  Created by Olesya Tranina on 06.07.2021.
//  
//

import UIKit
import Foundation

open class CollectionFocusablePlugin: CollectionFeaturePlugin, Focusable {

    // MARK: - Typealias

    public typealias Provider = CollectionGeneratorsProvider

    // MARK: - Properties

    open var delegate = FocusablePluginDelegate<Provider>()

}

public extension CollectionFeaturePlugin {

    static func focusable() -> CollectionFocusablePlugin {
        .init()
    }

}

open class TableFocusablePlugin: TableFeaturePlugin, Focusable {

    // MARK: - Typealias

    public typealias Provider = TableGeneratorsProvider

    // MARK: - Properties

    open var delegate = FocusablePluginDelegate<Provider>()

}

public extension TableFeaturePlugin {

    static func focusable() -> TableFocusablePlugin {
        .init()
    }

}
