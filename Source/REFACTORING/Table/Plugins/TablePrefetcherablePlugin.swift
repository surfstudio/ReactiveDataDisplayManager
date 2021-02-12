//
//  TablePrefetcherablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol ContentPrefetcher {
    associatedtype Content: Hashable

    /// Start prefetching data for the given identifiers.
    func startPrefetching(for requestIds: [Content])

    /// Stops prefetching images for the given identifiers.
    func cancelPrefetching(for requestIds: [Content])
}

/// Adds support for PrefetcherableFlow with prefetcher
///
/// ContentPrefetcher prefetches and caches data to eliminate delays when requesting the same data later.
public class TablePrefetcherablePlugin<Prefetcher: ContentPrefetcher, Generator: PrefetcherableFlow>: BaseTablePlugin<PrefetchEvent> {

    // MARK: - Private Properties

    private let prefetcher: Prefetcher

    // MARK: - Initialization

    /// - parameter prefetcher: Prefetches and caches data to eliminate delays when requesting the same data later.
    public init(prefetcher: Prefetcher) {
        self.prefetcher = prefetcher
    }

    // MARK: - PluginAction

    public override func process(event: PrefetchEvent, with manager: BaseTableManager?) {
        switch event {
        case .prefetch(let indexPaths):
            startPrefetching(from: manager, at: indexPaths)
        case .cancelPrefetching(let indexPaths):
            cancelPrefetching(from: manager, at: indexPaths)
        }
    }

}

// MARK: - Private Methods

private extension TablePrefetcherablePlugin {

    func startPrefetching(from manager: BaseTableManager?, at indexPaths: [IndexPath]) {
        let imageUrls = indexPaths.compactMap { getPrefetcherableFlowCell(from: manager, at: $0)?.requestId as? Prefetcher.Content }
        prefetcher.startPrefetching(for: imageUrls)
    }

    func cancelPrefetching(from manager: BaseTableManager?, at indexPaths: [IndexPath]) {
        let imageUrls = indexPaths.compactMap { getPrefetcherableFlowCell(from: manager, at: $0)?.requestId as? Prefetcher.Content }
        prefetcher.cancelPrefetching(for: imageUrls)
    }

    func getPrefetcherableFlowCell(from manager: BaseTableManager?, at indexPath: IndexPath) -> Generator? {
        return manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? Generator
    }

}
