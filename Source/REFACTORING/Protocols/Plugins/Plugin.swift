//
//  Plugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Use this class to extend collection functionality.
///
/// For example: add support of SelectableItem without overriding whole adapter
open class PluginAction<Event, Adapter> {

    func process(event: Event, with adapter: Adapter) {}
}
