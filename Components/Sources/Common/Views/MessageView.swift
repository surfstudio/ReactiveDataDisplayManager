//
//  MessageView.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 25.05.2023.
//
#if os(iOS)
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

            public let textColor: UIColor
            public let font: UIFont
            public let backgroundColor: UIColor

            public init(textColor: UIColor = .black, font: UIFont = .systemFont(ofSize: 16), backgroundColor: UIColor = .white) {
                self.textColor = textColor
                self.font = font
                self.backgroundColor = backgroundColor
            }

        }

        public enum TextType: Equatable {
            case string(String)
            /// Mind that attributed string may re-configure other model's properties.
            case attributedString(NSAttributedString)
        }

        public struct BorderStyle: Equatable {

            public let cornerRadius: CGFloat
            public let maskedCorners: CACornerMask
            public let borderWidth: CGFloat
            public let borderColor: CGColor

            public init(cornerRadius: CGFloat,
                        maskedCorners: CACornerMask,
                        borderWidth: CGFloat = 0,
                        borderColor: CGColor = UIColor.clear.cgColor) {
                self.cornerRadius = cornerRadius
                self.maskedCorners = maskedCorners
                self.borderWidth = borderWidth
                self.borderColor = borderColor
            }

        }

        // MARK: - Public properties

        public let text: TextType
        public let style: MessageStyle
        public var alignment: NSTextAlignment
        public var edgeInsets: UIEdgeInsets
        public let internalEdgeInsets: UIEdgeInsets
        public let borderStyle: BorderStyle

        // MARK: - Initialization

        public init(text: TextType,
                    style: MessageStyle,
                    alignment: NSTextAlignment,
                    externalEdgeInsets: UIEdgeInsets,
                    internalEdgeInsets: UIEdgeInsets,
                    borderStyle: BorderStyle) {
            self.text = text
            self.style = style
            self.alignment = alignment
            self.edgeInsets = externalEdgeInsets
            self.internalEdgeInsets = internalEdgeInsets
            self.borderStyle = borderStyle
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        self.backgroundColor = model.style.backgroundColor

        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        configureTextView(textView, with: model)
        textView.textColor = model.style.textColor
        textView.font = model.style.font
        textView.textAlignment = model.alignment

        wrap(subview: textView, with: model.internalEdgeInsets)

        layer.cornerRadius = model.borderStyle.cornerRadius
        layer.borderColor = model.borderStyle.borderColor
        layer.borderWidth = model.borderStyle.borderWidth
        layer.maskedCorners = model.borderStyle.maskedCorners

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
#endif
