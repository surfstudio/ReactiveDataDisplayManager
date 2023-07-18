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
    private var dataDetectionHandler: DataDetectionStyle.Handler?

}

// MARK: - ConfigurableItem

extension MessageView: ConfigurableItem {

    // MARK: - Model

    public struct Model: Equatable, AlignmentProvider {

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

            public static func dataDetection(_ value: DataDetectionStyle) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(dataDetection: value)
                    return model
                })
            }
            
            /// To set it to **false**, dataDetection and tapHandler must be nil
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
        private(set) public var dataDetection: DataDetectionStyle?
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

        mutating func set(dataDetection: DataDetectionStyle) {
            self.dataDetection = dataDetection
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

    }

    // MARK: - Methods

    public func configure(with model: Model) {
        textView.backgroundColor = .clear
        textView.isEditable = false
        setIsSelectablePropertyIfNeeded(for: model)
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

// MARK: - CalculatableHeightItem

extension MessageView: CalculatableHeightItem {

    public static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = getFrame(constraintRect: constraintRect, model: model)
        let height = ceil(boundingBox.height)

        return height
    }

}

// MARK: - CalculatableWidthItem

extension MessageView: CalculatableWidthItem {

    public static func getWidth(forHeight height: CGFloat, with model: Model) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = getFrame(constraintRect: constraintRect, model: model)
        let width = ceil(boundingBox.width)

        return width
    }

}

// MARK: - Private methods

private extension MessageView {

    static func getFrame(constraintRect: CGSize, model: Model) -> CGRect {
        switch model.text {
        case .string(let text):
            return text.boundingRect(with: constraintRect,
                                     options: .usesLineFragmentOrigin,
                                     attributes: model.getAttributes(),
                                     context: nil)
        case .attributedString(let attributedText):
            return attributedText.boundingRect(with: constraintRect,
                                               options: .usesLineFragmentOrigin,
                                               context: nil)
        }
    }

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
        dataDetectionHandler = model.dataDetection?.handler
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

    func handleDataDetection(_ data: URL) {
        dataDetectionHandler?(data)
    }

    func setIsSelectablePropertyIfNeeded(for model: Model) {
        if model.dataDetection != nil {
            textView.isSelectable = true
        } else {
            textView.isSelectable = model.selectable
        }
    }

}

// MARK: - UITextViewDelegate

extension MessageView: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        handleDataDetection(URL)
        return false
    }

}

extension MessageView.Model {

    func getAttributes() -> [NSAttributedString.Key: Any] {
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
            paragraphStyle.lineBreakMode = textLayout.lineBreakMode
            paragraphStyle.firstLineHeadIndent = edgeInsets.left
            paragraphStyle.headIndent = edgeInsets.right
            paragraphStyle.paragraphSpacingBefore = edgeInsets.top
            paragraphStyle.paragraphSpacing = edgeInsets.bottom
            paragraphStyle.alignment = textAlignment

            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[.font] = textStyle.font
            attributes[.foregroundColor] = textStyle.color
            attributes[.paragraphStyle] = paragraphStyle
            return attributes
        case .attributedString(let attributedText):
            return attributedText.attributes(at: 0, effectiveRange: nil)
        }
    }

}
#endif
