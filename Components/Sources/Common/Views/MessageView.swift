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

    private var heightConstraint: NSLayoutConstraint?
    private var labelView = LabelView(frame: .zero)

}

// MARK: - ConfigurableItem

extension MessageView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, InsetsProvider {

        // MARK: - Nested types

        public struct MessageStyle: Equatable {

            public let color: UIColor
            public let font: UIFont

            public init(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 16)) {
                self.color = color
                self.font = font
            }

        }

        // MARK: - Public properties

        public let text: String
        public let style: MessageStyle
        public let textAlignment: NSTextAlignment
        public var edgeInsets: UIEdgeInsets
        public let internalEdgeInsets: UIEdgeInsets

        // MARK: - Initialization

        public init(text: String, style: MessageStyle, textAlignment: NSTextAlignment, externalEdgeInsets: UIEdgeInsets, internalEdgeInsets: UIEdgeInsets) {
            self.text = text
            self.style = style
            self.textAlignment = textAlignment
            self.edgeInsets = externalEdgeInsets
            self.internalEdgeInsets = internalEdgeInsets
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        self.backgroundColor = .clear

        let labelViewStyle = LabelView.Model.TextStyle(color: model.style.color, font: model.style.font)
        let labelViewLayout = LabelView.Model.TextLayout(alignment: model.textAlignment)
        labelView.configure(with: LabelView.Model(text: .string(model.text),
                                                  style: labelViewStyle,
                                                  layout: labelViewLayout,
                                                  edgeInsets: .zero))
        wrap(subview: labelView, with: model.internalEdgeInsets)
        layer.cornerRadius = 9
        layer.borderColor = model.style.color.cgColor
        layer.borderWidth = 1

        layoutIfNeeded()
    }

}
