//
//  SeparatorView.swift
//  
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Base view to implement separator between other views or cells.
public class SeparatorView: UIView {

    // MARK: - Private properties

    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - ConfigurableItem

extension SeparatorView: ConfigurableItem {

    public struct Model: Equatable {
        public let height: CGFloat
        public let color: UIColor?
        public var edgeInsets: UIEdgeInsets

        public init(height: CGFloat, color: UIColor? = nil, edgeInsets: UIEdgeInsets = .zero) {
            self.height = height
            self.color = color
            self.edgeInsets = edgeInsets
        }
    }

    public func configure(with model: Model) {
        backgroundColor = model.color
        heightConstraint?.constant = model.height

        layoutIfNeeded()
    }

}

// MARK: - Private

private extension SeparatorView {

    func configureConstraints() {

        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }

}
