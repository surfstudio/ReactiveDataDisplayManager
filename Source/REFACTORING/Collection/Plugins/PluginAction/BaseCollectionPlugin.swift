//
//  BaseCollectionPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class BaseCollectionPlugin<Event>: PluginAction {

    open func process(event: Event, with manager: BaseCollectionManager?) {}

}
