//
//  StackTableCell+HighlitableItem.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import ReactiveDataComponents
import ReactiveDataDisplayManager
import UIKit

// internal project custom stack
final class TableVStack: TableStack, HighlightableItem {

    public init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, axis: .vertical, items: items)
    }

    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: .zero, insets: .zero, axis: .vertical, items: items)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - HighlightableItem

    public func applyUnhighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.cell?.contentView.backgroundColor = .white
        }
    }

    public func applyHighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.cell?.contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
    }

}

// internal project custom stack
final class TableHStack: HorizontalTableStack, HighlightableItem {

    public override init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, items: items)
    }

    public override init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: .zero, items: items)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - HighlightableItem

    public func applyUnhighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.cell?.contentView.backgroundColor = .white
        }
    }

    public func applyHighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.cell?.contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
    }

}
