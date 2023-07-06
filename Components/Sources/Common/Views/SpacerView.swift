//
//  Spacer.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Никита Коробейников on 23.09.2022.
//

import UIKit
import ReactiveDataDisplayManager

/// Base view to implement space between other views or cells.
public class SpacerView: UIView {

    // MARK: - Properties

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

extension SpacerView: ConfigurableItem {

    public struct Model: Equatable {
        public let height: CGFloat
        public let color: UIColor?

        public init(height: CGFloat, color: UIColor? = .clear) {
            self.height = height
            self.color = color
        }
    }

    public func configure(with model: Model) {
        backgroundColor = model.color
        heightConstraint?.constant = model.height
        layoutIfNeeded()
    }

    public func getSpacer(with model: Model) -> Self {
        configure(with: model)
        return self
    }

}

// MARK: - Private

private extension SpacerView {

    func configureConstraints() {

        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }

}

// MARK: - Wrapper

public protocol SpacerWrapper: ConfigurableItem {

    var spacer: SpacerView { get }

    func configureViews()
}

public extension SpacerWrapper where Model == SpacerView.Model {

    func configureViews() {
        backgroundColor = nil
        wrap(subview: spacer, with: .zero)
    }

    func configure(with model: Model) {
        spacer.configure(with: model)
    }

}
