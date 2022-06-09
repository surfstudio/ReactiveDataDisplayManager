//
//  TableGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class TableGeneratorsProvider: GeneratorsProvider {
    var delegate: TableDelegate?

    open var sections = [TableHeaderGenerator]()
    open var generators = [[TableCellGenerator]]() {
        willSet { checkPlugins(for: newValue) }
    }
}

// MARK: - Private

private extension TableGeneratorsProvider {

    /// Here is a list of plugins to check
    ///
    func checkPlugins(for sections: [[TableCellGenerator]]) {
        sections.forEach { generators in
            generators.forEach {
                checkPlugin(for: $0 as? SelectableItem)
                checkPlugin(for: $0 as? FoldableItem, pluginName: TableFoldablePlugin.pluginName)
            }
        }
    }

    /// For selectable plugin. Since it is connected basicly, you need to check the events
    ///
    func checkPlugin(for generator: SelectableItem?) {
        let plugin = delegate?.tablePlugins.plugins.first(where: { $0 is TableSelectablePlugin })
        let eventsNotEmpty = generator?.didSelectEvent.isEmpty == false || generator?.didDeselectEvent.isEmpty == false

        guard generator != nil && plugin == nil && eventsNotEmpty else { return }
        assertionFailure("❗️Include the CollectionSelectablePlugin.")
    }

    /// Universal plug-in checker
    /// - parameters:
    ///   - generator: Cast for ability item.
    ///   - pluginName: The name of the plugin using the specified ability item
    ///
    func checkPlugin(for generator: AnyObject?, pluginName: String) {
        let plugin = delegate?.tablePlugins.plugins.first(where: { $0.pluginName == pluginName })

        guard generator != nil && plugin == nil else { return }
        assertionFailure("❗️Include the \(pluginName).")
    }

}
