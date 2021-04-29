//
//  TableBuilderConfigurable.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.03.2021.
//

import UIKit

/// Entity configurable by builder
public protocol TableBuilderConfigurable {

    /// Configuration method
    ///
    /// - parameter builder: Use builder properties to initialise entity
    func configure<T: BaseTableManager>(with builder: TableBuilder<T>)
}
