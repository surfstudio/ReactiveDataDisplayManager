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

    public struct Model: Equatable, AlignmentProvider {

        // MARK: - Public properties

        public let text: TextValue = .string("")
        public let textStyle: TextStyle = .init()
        public let textLayout: TextLayout = .init()
        public let backgroundStyle: BackgroundStyle = .solid(.clear)
        public var alignment: Alignment
        public let internalEdgeInsets: UIEdgeInsets = .zero
        public let borderStyle: BorderStyle

    }

    // MARK: - Methods

    public func configure(with model: Model) {
//        self.backgroundColor = model.style.backgroundColor
//
//        textView.backgroundColor = .clear
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        configureTextView(textView, with: model)
//        textView.textColor = model.style.textColor
//        textView.font = model.style.font
//        textView.textAlignment = model.textAlignment

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
