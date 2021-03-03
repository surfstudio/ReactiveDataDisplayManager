//
//  TablePaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Input signals to control visibility of progressView in footer
public protocol PaginatableInput: class {

    /// Call it to control visibility of progressView in footer
    ///
    /// - parameter canIterate: `true` if want to show `progressView` in footer
    func update(canIterate: Bool)
}

/// Output signals for loading next page of content
public protocol PaginatableOutput: class {

    /// Called when collection scrolled to last cell
    ///
    /// - parameter input: input signals to hide  `progressView` from footer
    func loadNextPage(with input: PaginatableInput)
}

/// Plugin to display `progressView` while next page is loading
///
/// Show `progressView` on `willDisplay` last cell.
/// Hide `progressView` when finish loading request
public class TablePaginatablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Private Properties

    private let progressView: UIView
    private weak var output: PaginatableOutput?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside footer
    /// - parameter output: output signals to hide  `progressView` from footer
    init(progressView: UIView, with output: PaginatableOutput) {
        self.progressView = progressView
        self.output = output
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
                manager?.view.tableFooterView = progressView
                output?.loadNextPage(with: self)
            }
        default:
            break
        }
    }

}

// MARK: - RefreshableInput

extension TablePaginatablePlugin: PaginatableInput {

    public func update(canIterate: Bool) {
        progressView.isHidden = !canIterate
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
    /// - parameter output: output signals to hide  `progressView` from footer
    static func paginatable(progressView: UIView,
                            output: PaginatableOutput) -> TablePaginatablePlugin {
        .init(progressView: progressView, with: output)
    }

}
