//
//  BaseCollectionPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class BaseCollectionPlugin<Event>: PluginAction {

    public var pluginName: String {
        Self.pluginName
    }

    public init() { }

    open func setup(with manager: BaseCollectionManager?) {
        /// Most of plugins do not need any setup
    }

    open func process(event: Event, with manager: BaseCollectionManager?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

}
