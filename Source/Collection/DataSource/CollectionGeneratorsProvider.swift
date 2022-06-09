//
//  CollectionGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class CollectionGeneratorsProvider: GeneratorsProvider {

    var delegate: CollectionDelegate?

    open var sections = [CollectionHeaderGenerator]()
    open var footers = [CollectionFooterGenerator]()
    open var generators = [[CollectionCellGenerator]]() {
        willSet { checkPlugins(for: newValue) }
    }
}

// MARK: - Private

private extension CollectionGeneratorsProvider {

    /// Here is a list of plugins to check
    ///
    func checkPlugins(for sections: [[CollectionCellGenerator]]) {
        sections.forEach { generators in
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
