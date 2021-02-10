//
//  SectionTitleTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol SectionTitleDisplayble {
    /// The title as displayed in the section index of tableView
    var title: String? { get }
    /// When this property is set to true, then the title will be displayed in the section index of tableView
    var needSectionIndexTitle: Bool { get }
}

/// Use this dataSource if you need to configure the display of sectionIndexTitle
open class SectionTitleTableDataSource: BaseTableDataSource {

    // MARK: - Typealias

    public typealias SectionTitleTableHeaderGenerator = TableHeaderGenerator & SectionTitleDisplayble

    // MARK: - Private Properties

    private let titles: [String]?

    // MARK: - Public Methods

    /// - parameter titles: The array must includes title as displayed in the section index of tableView
    public init(titles: [String]? = nil) {
        self.titles = titles
    }

    // MARK: - UITableViewDataSource

    open override func numberOfSections(in tableView: UITableView) -> Int {
        titles?.count ?? provider?.sections.count ?? 0
    }

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionTitles = provider?.sections.compactMap { generator -> String? in
            guard let generator = generator as? SectionTitleTableHeaderGenerator else {
                return nil
            }
            return generator.needSectionIndexTitle ? generator.title : nil
        }
        return titles ?? sectionTitles
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return titles != nil ? index : getIndexForTitleFromHeaderGenerators(title, at: index)
    }

}

// MARK: - Private Methods

private extension SectionTitleTableDataSource {

    func getIndexForTitleFromHeaderGenerators(_ title: String, at index: Int) -> Int {
        guard let sections = provider?.sections else {
            return -1
        }

        for (index, generator) in sections.enumerated() {
            guard
                let generator = generator as? SectionTitleTableHeaderGenerator,
                generator.title == title
            else {
                continue
            }
            return index
        }
        return -1
    }

}
