//
//  CollectionFeaturePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 01.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

open class CollectionFeaturePlugin: FeaturePlugin {
    public typealias CollectionType = UICollectionView

    public var pluginName: String {
        Self.pluginName
    }

    public init() { }
}
