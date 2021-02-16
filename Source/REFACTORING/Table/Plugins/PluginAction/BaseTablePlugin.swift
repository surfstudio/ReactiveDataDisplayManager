//
//  BaseTablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class BaseTablePlugin<Event>: PluginAction {

    public init() { }

    open func process(event: Event, with manager: BaseTableManager?) {}

}
