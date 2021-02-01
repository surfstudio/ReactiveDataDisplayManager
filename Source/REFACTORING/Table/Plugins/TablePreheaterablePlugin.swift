//
//  TablePreheaterablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol RddmPreheater {
    /// Starte preheating data for the given identifiers.
    func startPrefetching(for requestIds: [Any])

    /// Stops preheating images for the given identifiers.
    func cancelPrefetching(for requestIds: [Any])
}

/// Adds support for PreheaterableFlow with preheater
/// 
/// Preheater prefetches and caches data to eliminate delays when requesting the same data later.
public class TablePreheaterablePlugin: PluginAction<PrefetchEvent, BaseTableStateManager> {

    // MARK: - Properties

    public var prefetchEvent = BaseEvent<[IndexPath]>()
    public var cancelPrefetchingEvent = BaseEvent<[IndexPath]>()

    // MARK: - Private Properties

    private let preheater: RddmPreheater

    // MARK: - Initialization

    /// - parameter preheater: Prefetches and caches data to eliminate delays when requesting the same data later.
    public init(preheater: RddmPreheater) {
        self.preheater = preheater
    }

    // MARK: - PluginAction

    override func process(event: PrefetchEvent, with manager: BaseTableStateManager?) {
        switch event {
        case .prefetch(let indexPaths):
            prefetchEvent.invoke(with: indexPaths)
            startPrefetching(from: manager, at: indexPaths)
        case .cancelPrefetching(let indexPaths):
            cancelPrefetchingEvent.invoke(with: indexPaths)
            cancelPrefetching(from: manager, at: indexPaths)
        }
    }

}

// MARK: - Private Methods

private extension TablePreheaterablePlugin {

    func startPrefetching(from manager: BaseTableStateManager?, at indexPaths: [IndexPath]) {
        let imageUrls = indexPaths.compactMap { getPreheaterableFlowCell(from: manager, at: $0)?.requestId }
        preheater.startPrefetching(for: imageUrls)
    }

    func cancelPrefetching(from manager: BaseTableStateManager?, at indexPaths: [IndexPath]) {
        let imageUrls = indexPaths.compactMap { getPreheaterableFlowCell(from: manager, at: $0)?.requestId }
        preheater.cancelPrefetching(for: imageUrls)
    }

    func getPreheaterableFlowCell(from manager: BaseTableStateManager?, at indexPath: IndexPath) -> PreheaterableFlow? {
        manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? PreheaterableFlow
    }

}
