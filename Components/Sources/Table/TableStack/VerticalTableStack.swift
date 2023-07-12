//
//  VerticalTableStack.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 12.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

open class VerticalTableStack: TableStack {

    // MARK: - Initialization

    public init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, axis: .vertical, items: items)
    }

    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: .zero, insets: .zero, axis: .vertical, items: items)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
