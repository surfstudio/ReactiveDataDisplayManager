//
//  PluginCollection.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// 
struct PluginCollection<Event, Manager> {

    typealias Plugin = PluginAction<Event, Manager>

    private var plugins = [Plugin]()

    mutating func add(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    func process(event: Event, with manager: Manager?) {
        plugins.forEach {
            $0.process(event: event, with: manager)
        }
    }
}
