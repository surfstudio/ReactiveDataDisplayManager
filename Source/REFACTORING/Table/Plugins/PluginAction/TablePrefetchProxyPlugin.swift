//
//  TablePrefetchProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Proxy of all `UITableViewDataSourcePrefetching` events
public class TablePrefetchProxyPlugin: BaseTablePlugin<PrefetchEvent> {

    // MARK: - Properties

    public var prefetchEvent = BaseEvent<[IndexPath]>()
    public var cancelPrefetchingEvent = BaseEvent<[IndexPath]>()

    // MARK: - BaseTablePlugin

    public override func process(event: PrefetchEvent, with manager: BaseTableManager?) {
        switch event {
        case .prefetch(let indexPaths):
            prefetchEvent.invoke(with: indexPaths)
        case .cancelPrefetching(let indexPaths):
            cancelPrefetchingEvent.invoke(with: indexPaths)
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to proxy  events of `UITableViewDataSourcePrefetching`
    static func proxyPrefetch() -> TablePrefetchProxyPlugin {
        .init()
    }

}
