//
//  SectionTitleDisplayble.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol SectionTitleDisplayble {
    /// The title as displayed in the section index of tableView
    var title: String { get }
    /// When this property is set to true, then the title will be displayed in the section index of tableView
    var needSectionIndexTitle: Bool { get }
}
