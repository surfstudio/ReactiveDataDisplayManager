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

    open func indexTitles(with provider: CollectionSectionsProvider?) -> [String]? {
        let generators = provider?.sections.compactMap { $0.generators }.reduce([], +)

        let itemTitles = generators?.compactMap { generator -> String? in
            guard let generator = generator as? GeneratorType else {
                return nil
            }
            return generator.needIndexTitle ? generator.title : nil
        }

        return itemTitles
    }

    open func indexPathForIndexTitle(_ title: String, at index: Int, with provider: CollectionSectionsProvider?) -> IndexPath {
        return getGeneratorIndexPath(with: title, for: provider)
    }

}

// MARK: - Private Methods

private extension CollectionItemTitleDisplayablePlugin {

    func getGeneratorIndexPath(with title: String, for provider: CollectionSectionsProvider?) -> IndexPath {
        guard let sections = provider?.sections else { return IndexPath() }
        for (sectionIndex, section) in sections.enumerated() {
            let generatorIndex = section.generators.firstIndex(where: { ($0 as? GeneratorType)?.title == title })

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
