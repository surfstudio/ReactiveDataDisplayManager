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

}

// MARK: - ConfigurableItem

extension LabelView: ConfigurableItem {

    // MARK: - Model

    public struct Model: InsetsProvider {

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

        public enum TextType: Equatable {
            case string(String)
            /// Mind that attributed string may re-configure other model's properties.
            case attributedString(NSAttributedString)
        }

        // MARK: - Public properties

        public let text: TextType
        public let style: TextStyle
        public let layout: TextLayout
        public var edgeInsets: UIEdgeInsets
        public var labelClass: UILabel.Type

        // MARK: - Initialization

        public init(text: TextType, style: TextStyle, layout: TextLayout, edgeInsets: UIEdgeInsets, labelClass: UILabel.Type = UILabel.self) {
            self.text = text
            self.style = style
            self.layout = layout
            self.edgeInsets = edgeInsets
            self.labelClass = labelClass
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        textView = model.labelClass.init()
        configureConstraints()

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

// MARK: - LabelView.Model Equatable

extension LabelView.Model: Equatable {

    public static func == (lhs: LabelView.Model, rhs: LabelView.Model) -> Bool {
        return lhs.style == rhs.style && lhs.layout == rhs.layout && lhs.text == rhs.text &&
        lhs.edgeInsets == rhs.edgeInsets && lhs.labelClass == rhs.labelClass
    }

}
