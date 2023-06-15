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

        public struct Property: Editor {
            public typealias Model = LabelView.Model

            private let closure: (Model) -> Model

            public init(closure: @escaping (Model) -> Model) {
                self.closure = closure
            }

            public func edit(_ model: LabelView.Model) -> LabelView.Model {
                return closure(model)
            }

            public static func text(_ value: TextValue) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(text: value)
                    return model
                })
            }

            public static func style(_ value: TextStyle) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(style: value)
                    return model
                })
            }

            public static func layout(_ value: TextLayout) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(layout: value)
                    return model
                })
            }

            public static func alignment(_ value: Alignment) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(alignment: value)
                    return model
                })
            }

            public static func textAlignment(_ value: NSTextAlignment) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(textAlignment: value)
                    return model
                })
            }
        }

        // MARK: - Public properties

        private(set) public var text: TextValue = .string("")
        private(set) public var style: TextStyle = .init()
        private(set) public var layout: TextLayout = .init()
        private(set) public var alignment: Alignment = .all(.zero)
        private(set) public var textAlignment: NSTextAlignment = .left

        mutating func set(text: TextValue) {
            self.text = text
        }

        mutating func set(style: TextStyle) {
            self.style = style
        }

        mutating func set(layout: TextLayout) {
            self.layout = layout
        }

        mutating func set(alignment: Alignment) {
            self.alignment = alignment
        }

        mutating func set(textAlignment: NSTextAlignment) {
            self.textAlignment = textAlignment
        }

        public static func build(@EditorBuilder<Property> content: () -> [Property]) -> Self {
            return content().reduce(.init(), { model, editor in
                editor.edit(model)
            })
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

    func configureText(with text: TextValue) {
        switch text {
        case .string(let text):
            label.text = text
        case .attributedString(let attrubutedText):
            label.attributedText = attrubutedText
        }
    }

}
