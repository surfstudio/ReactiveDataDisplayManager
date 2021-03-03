//
//  TablePaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to display `progressView` while next page is loading
///
/// Show `progressView` on `willDisplay` last cell.
/// Hide `progressView` when finish loading request
public class TablePaginatablePlugin: BaseTablePlugin<TableEvent> {

    public typealias PaginatableAction = () -> Void

    // MARK: - Private Properties

    private let progressView: UIView
    private let action: PaginatableAction

    /// Property which indicating availability of pages
    public private(set) var canIterate = false

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside footer
    /// - parameter action: closure with reaction to visibility of last cell
    init(progressView: UIView, action: @escaping PaginatableAction) {
        self.progressView = progressView
        self.action = action
    }

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            guard let generators = manager?.generators else {
                return
            }
            let lastSectionIndex = generators.count - 1
            let lastCellInLastSectionIndex = generators[lastSectionIndex].count - 1

            let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
            if indexPath == lastCellIndexPath {
                manager?.view.tableFooterView = canIterate ? progressView : nil
                action()
            }
        default:
            break
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to display `progressView` while next page is loading
    ///
    /// Show `progressView` on `willDisplay` last cell.
    /// Hide `progressView` when finish loading request
    ///
    /// - parameter progressView: indicator view to add inside footer
    /// - parameter action: closure with reaction to visibility of last cell
    static func paginatable(progressView: UIView,
                            action: @escaping TablePaginatablePlugin.PaginatableAction) -> TablePaginatablePlugin {
        .init(progressView: progressView, action: action)
    }

}
