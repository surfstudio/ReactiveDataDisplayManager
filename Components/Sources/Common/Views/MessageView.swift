//
//  MessageView.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 25.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Base view to implement label within cell
public class MessageView: UIView {

    // MARK: - Private properties

    private var textView = UITextView(frame: .zero)

}

// MARK: - ConfigurableItem

extension MessageView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, InsetsProvider, AlignmentProvider {

        // MARK: - Nested types

        public struct MessageStyle: Equatable {

            public let color: UIColor
            public let font: UIFont

            public init(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 16)) {
                self.color = color
                self.font = font
            }

        }

        public enum TextType: Equatable {
            case string(String)
            /// Mind that attributed string may re-configure other model's properties.
            case attributedString(NSAttributedString)
        }

        // MARK: - Public properties

        public let text: TextType
        public let style: MessageStyle
        public var alignment: NSTextAlignment
        public var edgeInsets: UIEdgeInsets
        public let internalEdgeInsets: UIEdgeInsets

        // MARK: - Initialization

        public init(text: TextType, style: MessageStyle, alignment: NSTextAlignment, externalEdgeInsets: UIEdgeInsets, internalEdgeInsets: UIEdgeInsets) {
            self.text = text
            self.style = style
            self.alignment = alignment
            self.edgeInsets = externalEdgeInsets
            self.internalEdgeInsets = internalEdgeInsets
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        self.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false

        configureTextView(textView, with: model)
        textView.textColor = model.style.color
        textView.font = model.style.font
        textView.textAlignment = model.alignment

        wrap(subview: textView, with: model.internalEdgeInsets)

        layer.cornerRadius = 9
        layer.borderColor = model.style.color.cgColor
        layer.borderWidth = 1

        layoutIfNeeded()
    }

}

// MARK: - Private methods

private extension MessageView {

    func configureTextView(_ textView: UITextView, with model: Model) {
        switch model.text {
        case .string(let string):
            textView.text = string
        case .attributedString(let attributedString):
            textView.attributedText = attributedString
        }
    }

}
