//
//  PluginCollection.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Collection to store and execute `PluginAction`
public struct PluginCollection<Plugin: PluginAction> {

    private(set) var plugins = [Plugin]()

    /// Add plugin to collection
    ///
    /// - parameter plugin: instance of `PluginAction`
    mutating func add(_ plugin: Plugin) {
        if plugins.contains(where: { $0.pluginName == plugin.pluginName }) {
            debugPrint("❗️ Plugin \(plugin.pluginName) added multiple times")
        }
        plugins.append(plugin)
    }

    /// Call `setup` for all elements of collection
    ///
    /// - parameter manager: instance of `DataDisplayManager`
    func setup(with manager: Plugin.Manager?) {
        plugins.forEach {
            $0.setup(with: manager)
        }
    }

    /// Call `process` for all elements of collection
    ///
    /// - parameter event: event of  view, delegate or dataSource
    /// - parameter manager: instance of `DataDisplayManager`
    func process(event: Plugin.Event, with manager: Plugin.Manager?) {
        plugins.forEach {
            $0.process(event: event, with: manager)
        }
    }
}
