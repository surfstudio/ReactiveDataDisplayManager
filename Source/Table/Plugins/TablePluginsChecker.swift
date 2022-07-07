//
//  TablePluginsChecker.swift
//  Pods
//
//  Created by porohov on 07.07.2022.
//
import UIKit

final class TablePluginsChecker {

    weak var delegate: TableDelegate?
    var generators: [[TableCellGenerator]]

    init(delegate: TableDelegate?, generators: [[TableCellGenerator]]) {
        self.delegate = delegate
        self.generators = generators
    }

    /// Async check plugins
    ///
    func asyncCheckPlugins() {
        DispatchQueue.main.async {
            self.checkPlugins()
        }
    }

    /// Here is a list of plugins to check
    ///
    func checkPlugins() {
        generators.forEach { generators in
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
