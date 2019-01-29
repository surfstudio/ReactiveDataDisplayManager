//
//  ConfigurableProtocol.swift
//  ReactiveDataDisplayManager
//
//  Created by Mikhail Monakov on 17/01/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

/// Protocol for UITableViewCell which is supposed to be used in BaseCellGenerator
public protocol Configurable where Self: UITableViewCell {

    associatedtype Model

    func configure(with model: Model)
    
}
