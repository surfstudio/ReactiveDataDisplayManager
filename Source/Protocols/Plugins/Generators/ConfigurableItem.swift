//
//  ConfigurableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for UIView (basically for UICollectionViewCell&UITableViewCell) which is supposed to be used in CellGenerators
public protocol ConfigurableItem where Self: UIView {

    associatedtype Model

    /// Method for SPM support
    ///
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?

    func configure(with model: Model)
    
}

public extension ConfigurableItem {

    static func bundle() -> Bundle? {
        return nil
    }

}
