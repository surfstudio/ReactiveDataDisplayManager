//
//  TableHeaderVisiblePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Plugin to define section that started to be displayed
public class TableHeaderVisiblePlugin: BaseTablePlugin<TableEvent> {

    public typealias Action = (Int) -> Void

    // MARK: - Private Properties

    private let action: Action

    // MARK: - Initialization

    /// - parameter action: closure returns the index of the section that started showing
    init(action: @escaping Action) {
        self.action = action
    }

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .willDisplayHeader(let section, _):
            willDisplayHeader(with: section, manager: manager)
        case .didEndDisplayHeader(let section, _):
            didEndDisplayHeader(with: section, manager: manager)
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableHeaderVisiblePlugin {

    func willDisplayHeader(with section: Int, manager: BaseTableManager?) {
        guard
            let pathsForVisibleRows = manager?.view?.indexPathsForVisibleRows,
            let firstPath = pathsForVisibleRows.first
        else { return }

        if firstPath.section == section {
            action(firstPath.section)
        }
    }

    func didEndDisplayHeader(with section: Int, manager: BaseTableManager?) {
        guard
            let pathsForVisibleRows = manager?.view?.indexPathsForVisibleRows,
            let lastPath = pathsForVisibleRows.last
        else { return }

        if lastPath.section >= section {
            action(section + 1)
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to define section that started to be displayed
    ///
    /// - parameter action: closure returns the index of the section that started showing
    static func headerIsVisible(action: @escaping TableHeaderVisiblePlugin.Action) -> TableHeaderVisiblePlugin {
        .init(action: action)
    }

}
