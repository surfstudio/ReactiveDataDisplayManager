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

    // MARK: - Constants

    private enum Constants {
        static let tapGestureName = "TapGesture"
    }

    // MARK: - Private properties

    private var textView = UITextView(frame: .zero)
    private var dataDetection: DataDetection?
    private var tapHandler: Model.TapHandler?

}

// MARK: - ConfigurableItem

extension MessageView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, AlignmentProvider {

        // MARK: - Nested types

        public typealias TapHandler = () -> Void

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

            public static func dataDetection(_ value: DataDetection) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(dataDetection: value)
                    return model
                })
            }

            public static func tapHandler(_ value: TapHandler?) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(tapHandler: value)
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
        private(set) public var dataDetection: DataDetection?
        private(set) public var tapHandler: TapHandler?
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

        mutating func set(dataDetection: DataDetection) {
            self.dataDetection = dataDetection
        }

        mutating func set(tapHandler: TapHandler?) {
            self.tapHandler = tapHandler
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
            lhs.dataDetection == rhs.dataDetection
        }

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        if let tapGesture = textView.gestureRecognizers?.first(where: { $0.name == Constants.tapGestureName }) {
            textView.removeGestureRecognizer(tapGesture)
        }

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

        textView.dataDetectorTypes = model.dataDetection?.dataDetectorTypes ?? []
        textView.linkTextAttributes = model.dataDetection?.linkTextAttributes
        textView.delegate = self
        dataDetection = model.dataDetection

        if let tapHandler = model.tapHandler {
            self.tapHandler = tapHandler
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            tapGesture.name = "TapGesture"
            textView.addGestureRecognizer(tapGesture)
        }
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

    func handleDataDetection(_ data: String) {
        guard let dataDetectionHandler = dataDetection?.dataDetectionHandler else {
            return
        }

        dataDetectionHandler(data)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let tapHandler = tapHandler else {
            return
        }
        tapHandler()
    }

}

// MARK: - UITextViewDelegate

extension MessageView: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        handleDataDetection(URL.absoluteString)
        return false
    }

}
#endif
