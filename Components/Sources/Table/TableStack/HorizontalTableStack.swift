//
//  HorizontalTableStack.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 12.07.2023.
//

import ReactiveDataDisplayManager
import UIKit

/// Base class for  horizontal table stack (generator)
open class HorizontalTableStack: TableStack {

    // MARK: - Initialization

    /// - Parameters:
    ///  - space: Space between items
    ///  - insets: Insets for stack
    ///  - items: Items for stack
    public init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, axis: .horizontal, items: items)
    }

    /// - Parameters:
    /// - items: Items for stack
    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: .zero, insets: .zero, axis: .horizontal, items: items)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
