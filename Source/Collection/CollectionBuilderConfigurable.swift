//
//  CollectionBuilderConfigurable.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.03.2021.
//

import UIKit

/// Entity configurable by builder
public protocol CollectionBuilderConfigurable {

    /// Configuration method
    ///
    /// - parameter builder: Use builder properties to initialise entity
    func configure<T: BaseCollectionManager>(with builder: CollectionBuilder<T>)
}
