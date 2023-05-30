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

    public init(labelClass: UILabel.Type) {
        super.init(frame: .zero)
        textView = labelClass.init()
        configureConstraints()
    }

}

// MARK: - ConfigurableItem

extension LabelView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, InsetsProvider {

        // MARK: - Nested types

        public struct TextStyle: Equatable {

            public let color: UIColor
            public let font: UIFont

            public init(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 16)) {
                self.color = color
                self.font = font
            }

        }

        public struct TextLayout: Equatable {

            public let alignment: NSTextAlignment
            public let lineBreakMode: NSLineBreakMode
            public let numberOfLines: Int

            public init(alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping, numberOfLines: Int = 0) {
                self.alignment = alignment
                self.lineBreakMode = lineBreakMode
                self.numberOfLines = numberOfLines
            }

        }

        // Mind that attributed string may re-configure other model`s properties

        public enum TextType: Equatable {
            case string(String)
            case attributedString(NSAttributedString)
        }

        // MARK: - Public properties

        public let text: TextType
        public let style: TextStyle
        public let layout: TextLayout
        public var edgeInsets: UIEdgeInsets

        // MARK: - Initialization

        public init(text: TextType, style: TextStyle, layout: TextLayout, edgeInsets: UIEdgeInsets) {
            self.text = text
            self.style = style
            self.layout = layout
            self.edgeInsets = edgeInsets
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        self.backgroundColor = .clear
        textView.backgroundColor = .clear
        textView.textColor = model.style.color
        textView.font = model.style.font

        textView.textAlignment = model.layout.alignment
        textView.lineBreakMode = model.layout.lineBreakMode
        textView.numberOfLines = model.layout.numberOfLines

        configureText(with: model.text)

        layoutIfNeeded()
    }

}

// MARK: - Private

private extension LabelView {

    func configureConstraints() {
        wrap(subview: textView, with: .zero)
    }

    func configureText(with text: Model.TextType) {
        switch text {
        case .string(let text):
            textView.text = text
        case .attributedString(let attrubutedText):
            textView.attributedText = attrubutedText
        }
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
