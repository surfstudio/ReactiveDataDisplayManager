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

    public struct Model: AlignmentProvider, TextProvider {

        // MARK: - Editor

        public struct Property: Editor {
            public typealias Model = LabelView.Model

            private let closure: (Model) -> Model

            public init(closure: @escaping (Model) -> Model) {
                self.closure = closure
            }

            public func edit(_ model: Model) -> Model {
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

        // MARK: - Mutation

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

        // MARK: - Builder

        public static func build(@EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
            return content(Property.self).reduce(.init(), { model, editor in
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

        model.text.apply(in: label)

        setNeedsLayout()
    }

}

// MARK: - CalculatableHeightItem

extension LabelView: CalculatableHeightItem {

    public static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = getFrame(constraintRect: constraintRect, model: model)
        let height = ceil(boundingBox.height)

        return height
    }

}

// MARK: - CalculatableHeightItem

extension LabelView: CalculatableWidthItem, FrameProvider {

    public static func getWidth(forHeight height: CGFloat, with model: Model) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = getFrame(constraintRect: constraintRect, model: model)
        let width = ceil(boundingBox.width)

        return width
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

extension LabelView.Model {

    public func getAttributes() -> [NSAttributedString.Key: Any] {
        switch text {
        case .string:
            let edgeInsets: UIEdgeInsets
            switch alignment {
            case .leading(let insets):
                edgeInsets = insets
            case .trailing(let insets):
                edgeInsets = insets
            case .all(let insets):
                edgeInsets = insets
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = layout.lineBreakMode
            paragraphStyle.firstLineHeadIndent = edgeInsets.left
            paragraphStyle.headIndent = edgeInsets.right
            paragraphStyle.paragraphSpacingBefore = edgeInsets.top
            paragraphStyle.paragraphSpacing = edgeInsets.bottom
            paragraphStyle.alignment = textAlignment

            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[.font] = style.font
            attributes[.foregroundColor] = style.color
            attributes[.paragraphStyle] = paragraphStyle
            return attributes
        case .attributedString(let attributedText):
            return attributedText.attributes(at: 0, effectiveRange: nil)
        }
    }

}

// MARK: - RegistrationTypeProvider

extension LabelView: RegistrationTypeProvider {

    public static var prefferedRegistration: RegistrationType { .class }

}
