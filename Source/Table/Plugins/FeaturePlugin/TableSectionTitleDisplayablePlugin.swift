//
//  TableSectionTitleDisplayablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to configure and display sectionIndexTitle
open class TableSectionTitleDisplayablePlugin: TableFeaturePlugin, TableSectionTitleDisplayable {

    public typealias GeneratorType = IndexTitleDisplaybleItem

    // MARK: - Private Properties

    private let titleWrapper: TableSectionTitleWrapper?

    // MARK: - Public Methods

    /// - parameter titleWrapper: wrapper that stores an array of title as displayed in the section index of tableView
    ///
    /// If you do not want to use a wrapper, use generators conforming to the `SectionTitleDisplayble`
    init(titleWrapper: TableSectionTitleWrapper?) {
        self.titleWrapper = titleWrapper
    }

    // MARK: - TableSectionTitleDisplayable

    open func numberOfSections(with provider: TableGeneratorsProvider?) -> Int {
        titleWrapper?.titles?.count ?? provider?.sections.count ?? 0
    }

    open func sectionIndexTitles(with provider: TableGeneratorsProvider?) -> [String]? {
        let sectionTitles = provider?.sections.compactMap { generator -> String? in
            guard let generator = generator as? GeneratorType else {
                return nil
            }
            return generator.needIndexTitle ? generator.title : nil
        }
        return titleWrapper?.titles ?? sectionTitles
    }

    open func sectionForSectionIndexTitle(_ title: String, at index: Int, with provider: TableGeneratorsProvider?) -> Int {
        return titleWrapper?.titles != nil ? index : getIndexForTitleFromHeaderGenerators(title, at: index, with: provider)
    }

}

// MARK: - Private Methods

private extension TableSectionTitleDisplayablePlugin {

    func getIndexForTitleFromHeaderGenerators(_ title: String, at index: Int, with provider: TableGeneratorsProvider?) -> Int {
        return provider?.sections.firstIndex(where: { ($0 as? IndexTitleDisplaybleItem)?.title == title }) ?? -1
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to configure and display sectionIndexTitle
    ///
    /// - parameter titleWrapper: wrapper that stores an array of title as displayed in the section index of tableView
    ///
    /// If you do not want to use a wrapper, use generators conforming to the `SectionTitleDisplayble`
    static func sectionTitleDisplayable(titleWrapper: TableSectionTitleWrapper? = nil) -> TableSectionTitleDisplayablePlugin {
        .init(titleWrapper: titleWrapper)
    }

}
