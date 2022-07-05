//
//  CollectionRefreshablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit

/// Plugin to show and hide `refreshControl`
@available(iOS 10, *)
public class CollectionRefreshablePlugin: BaseCollectionPlugin<ScrollEvent> {

    // MARK: - Private Properties

    private let refreshControl: UIRefreshControl
    private weak var output: RefreshableOutput?

    private var isRefreshingStarted = false

    // MARK: - Initialization

    /// - parameter refreshControl: closure with reaction to visibility of last cell
    /// - parameter output: output signals to notify about refreshing
    init(refreshControl: UIRefreshControl, with output: RefreshableOutput) {
        self.refreshControl = refreshControl
        self.output = output
    }

    // MARK: - BaseCollectionPlugin

    public override func setup(with manager: BaseCollectionManager?) {
        manager?.view.refreshControl = refreshControl
    }

    public override func process(event: ScrollEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .willEndDragging:
            if refreshControl.isRefreshing && !isRefreshingStarted {
                output?.refreshContent(with: self)
                isRefreshingStarted = true
            }
        default:
            break
        }
    }

}

// MARK: - RefreshableInput

@available(iOS 10, *)
extension CollectionRefreshablePlugin: RefreshableInput {

    public func endRefreshing() {
        refreshControl.endRefreshing()
        isRefreshingStarted = false
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to show and hide `refreshControl`
    ///
    /// Show `refreshControl` on refreshing
    /// Hide `refreshControl` when finish loading request
    ///
    /// - parameter refreshControl: closure with reaction to visibility of last cell
    /// - parameter output: output signals to notify about refreshing
    @available(iOS 10, *)
    static func refreshable(refreshControl: UIRefreshControl,
                            output: RefreshableOutput) -> CollectionRefreshablePlugin {
        .init(refreshControl: refreshControl, with: output)
    }

}
#endif
