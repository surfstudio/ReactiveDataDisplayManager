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

    private var label: UILabel = .init(frame: .zero)

}

// MARK: - ConfigurableItem

extension LabelView: ConfigurableItem {

    // MARK: - Model

    public struct Model: AlignmentProvider {

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

            public let lineBreakMode: NSLineBreakMode
            public let numberOfLines: Int

            public init(lineBreakMode: NSLineBreakMode = .byWordWrapping, numberOfLines: Int = 0) {
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
        public let alignment: Alignment
        public let textAlignment: NSTextAlignment

        // MARK: - Initialization

        public init(text: TextType,
                    style: TextStyle,
                    layout: TextLayout,
                    textAlignment: NSTextAlignment,
                    viewAlignment: Alignment = .all(.zero)) {
            self.text = text
            self.style = style
            self.layout = layout
            self.textAlignment = textAlignment
            self.alignment = viewAlignment
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        configureConstraints()

        self.backgroundColor = .clear
        label.backgroundColor = .clear
        label.textColor = model.style.color
        label.font = model.style.font

        label.textAlignment = model.textAlignment
        label.lineBreakMode = model.layout.lineBreakMode
        label.numberOfLines = model.layout.numberOfLines

        configureText(with: model.text)

        setNeedsLayout()
    }

}

// MARK: - Private

private extension LabelView {

    func configureConstraints() {
        wrap(subview: label, with: .zero)
    }

    func configureText(with text: Model.TextType) {
        switch text {
        case .string(let text):
            label.text = text
        case .attributedString(let attrubutedText):
            label.attributedText = attrubutedText
        }
    }

}
