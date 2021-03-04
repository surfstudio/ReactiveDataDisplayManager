//
//  CollectionItemTitleDisplayablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to configure and display of itemIndexTitle
open class CollectionItemTitleDisplayablePlugin: CollectionFeaturePlugin, CollectionItemTitleDisplayable {

    public typealias GeneratorType = IndexTitleDisplaybleItem

    // MARK: - SectionTitleDisplayable

    open func indexTitles(with provider: CollectionGeneratorsProvider?) -> [String]? {
        let generators = provider?.generators.reduce([], +)

        let itemTitles = generators?.compactMap { generator -> String? in
            guard let generator = generator as? GeneratorType else {
                return nil
            }
            return generator.needIndexTitle ? generator.title : nil
        }

        return itemTitles
    }

    open func indexPathForIndexTitle(_ title: String, at index: Int, with provider: CollectionGeneratorsProvider?) -> IndexPath {
        return getGeneratorIndexPath(with: title, for: provider)
    }

}

// MARK: - Private Methods

private extension CollectionItemTitleDisplayablePlugin {

    func getGeneratorIndexPath(with title: String, for provider: CollectionGeneratorsProvider?) -> IndexPath {
        guard let generators = provider?.generators else { return IndexPath() }
        for (sectionIndex, section) in generators.enumerated() {
            let generatorIndex = section.firstIndex(where: { ($0 as? GeneratorType)?.title == title })

            if let generatorIndex = generatorIndex {
                return IndexPath(item: generatorIndex, section: sectionIndex)
            }
        }
        return IndexPath()
    }

}

// MARK: - Public init

public extension CollectionFeaturePlugin {

    /// Plugin to configure and display sectionIndexTitle
    static func sectionTitleDisplayable() -> CollectionItemTitleDisplayablePlugin {
        .init()
    }

}
