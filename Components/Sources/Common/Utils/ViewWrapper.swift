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

}

public extension ViewWrapper where Self: UIView {

    func configure(with model: NestedView.Model) {
        let insets = (model as? InsetsProvider)?.edgeInsets ?? .zero
        wrap(subview: nestedView, with: insets)
        nestedView.configure(with: model)
    }

}


