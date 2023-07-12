//
//  HorizontalCollectionStack.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 12.07.2023.
//

import ReactiveDataDisplayManager
import UIKit

open class HorizontalCollectionStack: CollectionStack {

    // MARK: - Initialization

    public init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, axis: .horizontal, items: items)
    }

    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: 0, insets: .zero, axis: .horizontal, items: items)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
