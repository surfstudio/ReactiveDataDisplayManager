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
    private var widthConstraint: NSLayoutConstraint?

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

        public let size: ViewSize
        public let color: UIColor?

        public init(size: ViewSize, color: UIColor? = nil) {
            self.size = size
            self.color = color
        }
    }

    public func configure(with model: Model) {
        backgroundColor = model.color
        switch model.size {
        case .height(let height):
            heightConstraint?.constant = height
            heightConstraint?.isActive = true
            widthConstraint?.isActive = false

        case .width(let width):
            widthConstraint?.constant = width
            widthConstraint?.isActive = true
            heightConstraint?.isActive = false
        }
        layoutIfNeeded()
    }

}

// MARK: - Static methods

extension SpacerView {

    static func getCellSize(for model: Model, width: CGFloat) -> CGSize {
        return CGSize(width: width, height: model.height)
    }

}

// MARK: - Private

private extension SpacerView {

    func configureConstraints() {

        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = widthAnchor.constraint(equalToConstant: 0)
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
