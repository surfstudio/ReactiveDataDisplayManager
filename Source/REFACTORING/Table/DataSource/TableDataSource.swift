//
//  TableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol TableDataSource: UITableViewDataSource, UITableViewDataSourcePrefetching {
    var provider: TableGeneratorsProvider? { get set }

    var prefetchPlugins: PluginCollection<BaseTablePlugin<PrefetchEvent>> { get set }
    var tablePlugins: PluginCollection<BaseTablePlugin<TableEvent>> { get set }
    var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable? { get set }
    var movablePlugin: TableMovableDataSource? { get set }
}
