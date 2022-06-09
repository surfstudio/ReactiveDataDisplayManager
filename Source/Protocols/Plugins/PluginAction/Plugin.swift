//
//  Plugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Use this class to extend collection functionality.
///
/// **For example**: add support of SelectableItem without overriding whole adapter
public protocol PluginAction {
    associatedtype Event
    associatedtype Manager: DataDisplayManager

    /// Plugin name, must match child class name
    var pluginName: String { get }

    /// Setup optional references to manager properties
    ///
    /// - parameter manager: instance of `DataDisplayManager`
    func setup(with manager: Manager?)

    /// Add reaction on some event to manager
    ///
    /// - parameter event: event of  view, delegate or dataSource
    /// - parameter manager: instance of `DataDisplayManager`
    func process(event: Event, with manager: Manager?)
}

extension PluginAction {
    public static var pluginName: String { String(describing: Self.self) }
}
