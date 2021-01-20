//
//  PluginCollection.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// 
struct PluginCollection<Event, Adapter> {

    typealias Plugin = PluginAction<Event, Adapter>

    private var plugins = [Plugin]()

    mutating func add(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    func process(event: Event, with adapter: Adapter) {
        plugins.forEach {
            $0.process(event: event, with: adapter)
        }
    }
}
