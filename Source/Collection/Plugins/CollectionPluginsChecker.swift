//
//  CollectionPluginsChecker.swift
//  DifferenceKit
//
//  Created by porohov on 07.07.2022.
//
import UIKit

final class CollectionPluginsChecker {

    weak var delegate: CollectionDelegate?
    var generators: [[CollectionCellGenerator]]

    init(delegate: CollectionDelegate?, generators: [[CollectionCellGenerator]]) {
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
                checkPlugin(for: $0 as? CollectionFoldableItem, pluginName: CollectionFoldablePlugin.pluginName)
            }
        }
    }

    /// For selectable plugin. Since it is connected basicly, you need to check the events
    ///
    func checkPlugin(for generator: SelectableItem?) {
        let plugin = delegate?.collectionPlugins.plugins.first(where: { $0 is CollectionSelectablePlugin })
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
        let plugin = delegate?.collectionPlugins.plugins.first(where: { $0.pluginName == pluginName })

        guard generator != nil && plugin == nil else { return }
        assertionFailure("❗️Include the \(pluginName).")
    }

}
