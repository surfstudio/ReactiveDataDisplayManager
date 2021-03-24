//
//  CollectionPrefetchProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Proxy of all `UICollectionViewDataSourcePrefetching` events
public class CollectionPrefetchProxyPlugin: BaseCollectionPlugin<PrefetchEvent> {

    // MARK: - Properties

    public var prefetchEvent = BaseEvent<[IndexPath]>()
    public var cancelPrefetchingEvent = BaseEvent<[IndexPath]>()

    // MARK: - BaseCollectionPlugin

    public override func process(event: PrefetchEvent, with manager: BaseCollectionManager?) {
        switch event {
        case .prefetch(let indexPaths):
            prefetchEvent.invoke(with: indexPaths)
        case .cancelPrefetching(let indexPaths):
            cancelPrefetchingEvent.invoke(with: indexPaths)
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to proxy events of `UICollectionViewDataSourcePrefetching`
    static func proxyPrefetch(to scrollPosition: UICollectionView.ScrollPosition) -> CollectionPrefetchProxyPlugin {
        .init()
    }

}
