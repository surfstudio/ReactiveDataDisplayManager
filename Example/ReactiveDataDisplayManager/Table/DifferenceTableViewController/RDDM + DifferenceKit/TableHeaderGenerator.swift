//
//  TableHeaderGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import DifferenceKit

extension TableHeaderGenerator: Differentiable {

    // MARK: - Differentiable

    public var differenceIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }

    public func isContentEqual(to source: TableHeaderGenerator) -> Bool {
        return source === self
    }

}
