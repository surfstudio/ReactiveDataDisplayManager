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
public protocol PluginAction {
    associatedtype Event
    associatedtype Manager

    func setup(with manager: Manager?)
    func process(event: Event, with manager: Manager?)
}

// MARK: - Defaults

public extension PluginAction {

    func setup(with manager: Manager?) {
        /// Most of plugins do not need any setup
    }

}
