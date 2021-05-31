//
//  ConfigurableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `UIView` (basically for `UICollectionViewCell` or `UITableViewCell`) which is supposed to be used in CellGenerators
public protocol ConfigurableItem where Self: UIView {

    associatedtype Model

    /// Method for SPM support
    ///
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?

    /// Configure `UView` and subviews with content model
    ///
    /// - parameter model: instance of content model, which can contains:
    ///     - texts
    ///     - images
    ///     - colors
    ///     - delegate or event closure
    func configure(with model: Model)

}

public extension ConfigurableItem {

    static func bundle() -> Bundle? {
        return nil
    }

}
