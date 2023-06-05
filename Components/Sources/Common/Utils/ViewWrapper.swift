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

    /// Previous value of `UIEdgeInsets` applyed to `nestedView`
    var cachedInsets: UIEdgeInsets? { get set }
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
        let insets = (model as? InsetsProvider)?.edgeInsets ?? .zero
        let alignment = (model as? AlignmentProvider)?.alignment

        guard alignment != cachedAlignment || insets != cachedInsets else {
            return
        }

        nestedView.removeFromSuperview()
        switch alignment {
        case .trailing:
            wrapWithLeadingGreaterThenOrEqualRule(subview: nestedView, with: insets)
        case .leading:
            wrapWithTrailingLessThenOrEqualRule(subview: nestedView, with: insets)
        case .none:
            wrap(subview: nestedView, with: insets)
        }
        cachedInsets = insets
        cachedAlignment = alignment
    }

}
