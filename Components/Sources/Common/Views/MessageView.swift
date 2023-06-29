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
    private var dataDetectionHandler: Model.DataDetectionHandler?

}

// MARK: - ConfigurableItem

extension MessageView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, AlignmentProvider {

        // MARK: - Nested types

        public typealias DataDetectionHandler = (DataDetectionType, String) -> Void

        public enum DataDetectionType {
            case link
            case phoneNumber
        }

        // MARK: - Editor

        public struct Property: Editor {
            public typealias Model = MessageView.Model

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

            public static func insets(_ value: UIEdgeInsets) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(insets: value)
                    return model
                })
            }

            public static func background(_ value: BackgroundStyle) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(background: value)
                    return model
                })
            }

            public static func border(_ value: BorderStyle) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(border: value)
                    return model
                })
            }

            public static func dataDetectorTypes(_ value: UIDataDetectorTypes) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(dataDetectorTypes: value)
                    return model
                })
            }

            public static func linkTextAttributes(_ value: [NSAttributedString.Key: Any]?) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(linkTextAttributes: value)
                    return model
                })
            }

            public static func dataDetectionHandler(_ value: DataDetectionHandler?) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(dataDetectionHandler: value)
                    return model
                })
            }

            public static func selectable(_ selectable: Bool) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(selectable: selectable)
                    return model
                })
            }
        }

        // MARK: - Public properties

        private(set) public var text: TextValue = .string("")
        private(set) public var textStyle: TextStyle = .init()
        private(set) public var textLayout: TextLayout = .init()
        private(set) public var textAlignment: NSTextAlignment = .left
        private(set) public var backgroundStyle: BackgroundStyle = .solid(.clear)
        private(set) public var alignment: Alignment = .all(.zero)
        private(set) public var internalEdgeInsets: UIEdgeInsets = .zero
        private(set) public var borderStyle: BorderStyle?
        private(set) public var dataDetectorTypes: UIDataDetectorTypes = []
        private(set) public var linkTextAttributes: [NSAttributedString.Key: Any]?
        private(set) public var dataDetectionHandler: DataDetectionHandler?
        private(set) public var selectable: Bool = false

        // MARK: - Mutation

        mutating func set(text: TextValue) {
            self.text = text
        }

        mutating func set(style: TextStyle) {
            self.textStyle = style
        }

        mutating func set(layout: TextLayout) {
            self.textLayout = layout
        }

        mutating func set(alignment: Alignment) {
            self.alignment = alignment
        }

        mutating func set(textAlignment: NSTextAlignment) {
            self.textAlignment = textAlignment
        }

        mutating func set(insets: UIEdgeInsets) {
            self.internalEdgeInsets = insets
        }

        mutating func set(background: BackgroundStyle) {
            self.backgroundStyle = background
        }

        mutating func set(border: BorderStyle) {
            self.borderStyle = border
        }

        mutating func set(dataDetectorTypes: UIDataDetectorTypes) {
            self.dataDetectorTypes = dataDetectorTypes
        }

        mutating func set(linkTextAttributes: [NSAttributedString.Key: Any]?) {
            self.linkTextAttributes = linkTextAttributes
        }

        mutating func set(dataDetectionHandler: DataDetectionHandler?) {
            self.dataDetectionHandler = dataDetectionHandler
        }

        mutating func set(selectable: Bool) {
            self.selectable = selectable
        }

        // MARK: - Builder

        public static func build(@EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
            return content(Property.self).reduce(.init(), { model, editor in
                editor.edit(model)
            })
        }

        // MARK: - Equatable

        public static func == (lhs: MessageView.Model, rhs: MessageView.Model) -> Bool {
            return lhs.text == rhs.text &&
            lhs.textStyle == rhs.textStyle &&
            lhs.textLayout == rhs.textLayout &&
            lhs.textAlignment == rhs.textAlignment &&
            lhs.backgroundStyle == rhs.backgroundStyle &&
            lhs.alignment == rhs.alignment &&
            lhs.internalEdgeInsets == rhs.internalEdgeInsets &&
            lhs.borderStyle == rhs.borderStyle &&
            lhs.dataDetectorTypes == rhs.dataDetectorTypes &&
            areDictionariesEqual(lhs.linkTextAttributes, rhs.linkTextAttributes)
        }

        // MARK: - Private methods

        private static func areDictionariesEqual(_ lhs: [NSAttributedString.Key: Any]?, _ rhs: [NSAttributedString.Key: Any]?) -> Bool {
            guard let lhs = lhs, let rhs = rhs else {
                return lhs == nil && rhs == nil
            }

            return NSDictionary(dictionary: lhs).isEqual(to: rhs)
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {

        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = model.selectable
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = false
        configureTextView(textView, with: model)
        textView.textColor = model.textStyle.color
        textView.font = model.textStyle.font
        textView.textAlignment = model.textAlignment

        wrap(subview: textView, with: model.internalEdgeInsets)

        applyBackground(style: model.backgroundStyle)
        applyBorder(style: model.borderStyle)

        layoutIfNeeded()
    }

    public func setLinkTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) {
        textView.linkTextAttributes = attributes
    }

    public func setDataDetectorTypes(_ types: UIDataDetectorTypes) {
        textView.dataDetectorTypes = types
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

        textView.dataDetectorTypes = model.dataDetectorTypes
        textView.linkTextAttributes = model.linkTextAttributes
        textView.delegate = self
        dataDetectionHandler = model.dataDetectionHandler
    }

    func applyBackground(style: BackgroundStyle) {
        switch style {
        case .solid(let color):
            backgroundColor = color
        }
    }

    func applyBorder(style: BorderStyle?) {
        guard let borderStyle = style else {
            return
        }
        layer.cornerRadius = borderStyle.cornerRadius
        layer.borderColor = borderStyle.borderColor
        layer.borderWidth = borderStyle.borderWidth
        layer.maskedCorners = borderStyle.maskedCorners
    }

    func handleDataDetection(_ type: Model.DataDetectionType, _ data: String) {
        guard let dataDetectionHandler = dataDetectionHandler else {
            return
        }

        dataDetectionHandler(type, data)
    }

}

// MARK: - UITextViewDelegate

extension MessageView: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        handleDataDetection(.link, URL.absoluteString)
        return false
    }

}
#endif
