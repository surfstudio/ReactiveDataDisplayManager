//
//  TableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol TableDelegate: TableBuilderConfigurable, UITableViewDelegate {
    var manager: BaseTableManager? { get set }

    var tablePlugins: PluginCollection<BaseTablePlugin<TableEvent>> { get set }
    var scrollPlugins: PluginCollection<BaseTablePlugin<ScrollEvent>> { get set }
    var movablePlugin: MovablePluginDelegate<TableGeneratorsProvider>? { get set }
    #if os(iOS)
    @available(iOS 11.0, *)
    var swipeActionsPlugin: TableSwipeActionsConfigurable? { get set }
    #endif
}
