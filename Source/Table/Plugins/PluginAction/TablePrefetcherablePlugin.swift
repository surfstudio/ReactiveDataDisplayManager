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

    /// Stops prefetching data for the given identifiers.
    func cancelPrefetching(for requestIds: [Content])
}

/// Plugin to support `PrefetcherableItem` with prefetcher
///
/// `ContentPrefetcher` prefetches and caches data to eliminate delays when requesting the same data later.
public class TablePrefetcherablePlugin<Prefetcher: ContentPrefetcher, Generator: PrefetcherableItem>: BaseTablePlugin<PrefetchEvent> {

    // MARK: - Private Properties

    private let prefetcher: Prefetcher

    // MARK: - Initialization

    /// - parameter prefetcher: Prefetches and caches data to eliminate delays when requesting the same data later.
    init(prefetcher: Prefetcher) {
        self.prefetcher = prefetcher
    }

    // MARK: - BaseTablePlugin

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
        let contents = indexPaths.compactMap { getPrefetcherableFlowCell(from: manager, at: $0)?.requestId as? Prefetcher.Content }
        prefetcher.startPrefetching(for: contents)
    }

    func cancelPrefetching(from manager: BaseTableManager?, at indexPaths: [IndexPath]) {
        let contents = indexPaths.compactMap { getPrefetcherableFlowCell(from: manager, at: $0)?.requestId as? Prefetcher.Content }
        prefetcher.cancelPrefetching(for: contents)
    }

    func getPrefetcherableFlowCell(from manager: BaseTableManager?, at indexPath: IndexPath) -> Generator? {
        return manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? Generator
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to support `PrefetcherableItem` with prefetcher
    ///
    /// - parameter prefetcher: Prefetches and caches data to eliminate delays when requesting the same data later.
    // swiftlint:disable operator_usage_whitespace
    static func prefetch<Prefetcher: ContentPrefetcher,
                         Generator: PrefetcherableItem>(prefetcher: Prefetcher) -> TablePrefetcherablePlugin<Prefetcher, Generator> {
        .init(prefetcher: prefetcher)
    }
    // swiftlint:enable operator_usage_whitespace

}
