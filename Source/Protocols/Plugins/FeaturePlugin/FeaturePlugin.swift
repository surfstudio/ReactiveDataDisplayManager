//
//  FeaturePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Use this class to extend collection functionality
public protocol FeaturePlugin {
    associatedtype CollectionType

    /// Plugin name, must match child class name
    var pluginName: String { get }
}

extension FeaturePlugin {
    static var pluginName: String { String(describing: Self.self) }
}
