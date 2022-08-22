//
//  TableFeaturePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 01.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

open class TableFeaturePlugin: FeaturePlugin {
    public typealias CollectionType = UITableView

    public init() { }

    public var pluginName: String {
        Self.pluginName
    }
}
