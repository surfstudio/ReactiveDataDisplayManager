//
//  PluginCollection.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Collection to store and execute pluginActions
public struct PluginCollection<Plugin: PluginAction> {

    private var plugins = [Plugin]()

    mutating func add(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    func process(event: Plugin.Event, with manager: Plugin.Manager?) {
        plugins.forEach {
            $0.process(event: event, with: manager)
        }
    }
}
