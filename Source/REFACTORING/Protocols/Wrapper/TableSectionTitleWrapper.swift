//
//  TableSectionTitleWrapper.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public class TableSectionTitleWrapper {

    // MARK: - Properties

    /// Array includes titles displayed in the section index of tableView
    public var titles: [String]?

    // MARK: - Initialization

    /// - parameter titles: The array must includes title as displayed in the section index of tableView
    public init(titles: [String]? = nil) {
        self.titles = titles
    }

}
