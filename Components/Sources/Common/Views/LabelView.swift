//
//  LabelView.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Base view to implement label within cell
public class LabelView: UIView {

    // MARK: - Private properties

    private var heightConstraint: NSLayoutConstraint?
    private var textView = UILabel(frame: .zero)

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

extension LabelView: ConfigurableItem {

    public typealias TextStyle = (color: UIColor, font: UIFont)
    public typealias TextLayout = (alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode, numberOfLines: Int)

    public struct Model {
        public let text: String
        public let style: TextStyle
        public let layout: TextLayout
        public let edgeInsets: UIEdgeInsets

        public init(text: String, style: TextStyle, layout: TextLayout, edgeInsets: UIEdgeInsets) {
            self.text = text
            self.style = style
            self.layout = layout
            self.edgeInsets = edgeInsets
        }
    }

    public func configure(with model: Model) {
        self.backgroundColor = .clear
        textView.backgroundColor = .clear
        textView.text = model.text
        textView.textColor = model.style.color
        textView.font = model.style.font

        textView.textAlignment = model.layout.alignment
        textView.lineBreakMode = model.layout.lineBreakMode
        textView.numberOfLines = model.layout.numberOfLines

        setNeedsUpdateConstraints()
    }

}

// MARK: - Private

private extension LabelView {

    func configureConstraints() {
        wrap(subview: textView, with: .zero)
    }

}

// MARK: - Wrapper

public protocol LabelWrapper: ConfigurableItem {

    var label: LabelView { get }

}

public extension LabelWrapper where Model == LabelView.Model {

    func configure(with model: Model) {
        wrap(subview: label, with: model.edgeInsets)
        label.configure(with: model)
    }

}

// MARK: - Equatable

extension LabelView.Model: Equatable {

    public static func == (lhs: LabelView.Model, rhs: LabelView.Model) -> Bool {
        return lhs.text == rhs.text && lhs.style == rhs.style
        && lhs.layout == rhs.layout && lhs.edgeInsets == rhs.edgeInsets
    }

}
