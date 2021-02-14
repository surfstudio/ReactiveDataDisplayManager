//
//  TableHeaderVisiblePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Adds the definition of the section that started to be displayed
public class TableHeaderVisiblePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Private Properties

    private let action: (Int) -> Void

    // MARK: - Initialization

    /// - parameter action: closure returns the index of the section that started showing
    public init(action: @escaping (Int) -> Void) {
        self.action = action
    }

    // MARK: - PluginAction

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .willDisplayHeader(let section):
            willDisplayHeader(with: section, manager: manager)
        case .didEndDisplayHeader(let section):
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
