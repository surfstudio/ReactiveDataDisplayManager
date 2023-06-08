//
//  ViewWrapper.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 29.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

public protocol ViewWrapper: ConfigurableItem {

    associatedtype NestedView: ConfigurableItem

    /// Inner configurable view with content
    var nestedView: NestedView { get }

    /// Previous value of `Alignment` applyed to `nestedView`
    var cachedAlignment: Alignment? { get set }

}

// MARK: - Common implementation

public extension ViewWrapper where Self: UIView {

    func configure(with model: NestedView.Model) {
        wrapNestedViewIfNeeded(with: model)
        nestedView.configure(with: model)
    }

}

// MARK: - Private

private extension ViewWrapper where Self: UIView {

    /// Adding nestedView as subview only if constraint specific parameters were changed
    func wrapNestedViewIfNeeded(with model: NestedView.Model) {
        let alignment = (model as? AlignmentProvider)?.alignment

        guard alignment != cachedAlignment else {
            return
        }

        nestedView.removeFromSuperview()
        switch alignment {
        case .trailing(let insets):
            wrapWithLeadingGreaterThenOrEqualRule(subview: nestedView, with: insets)
        case .leading(let insets):
            wrapWithTrailingLessThenOrEqualRule(subview: nestedView, with: insets)
        case .all(let insets):
            wrap(subview: nestedView, with: insets)
        case .none:
            break
        }
        cachedAlignment = alignment
    }

}
