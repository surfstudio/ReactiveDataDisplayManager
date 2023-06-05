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

    var nestedView: NestedView { get }

    var cachedInsets: UIEdgeInsets? { get set }
    var cachedAlignment: NSTextAlignment? { get set }

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
        let alignment = (model as? AlignmentProvider)?.alignment ?? .center

        guard alignment != cachedAlignment || insets != cachedInsets else {
            return
        }

        nestedView.removeFromSuperview()
        switch alignment {
        case .right:
            wrapWithLeadingGreaterThenOrEqualRule(subview: nestedView, with: insets)
        case .left:
            wrapWithTrailingLessThenOrEqualRule(subview: nestedView, with: insets)
        default:
            wrap(subview: nestedView, with: insets)
        }
        cachedInsets = insets
        cachedAlignment = alignment
    }

}
