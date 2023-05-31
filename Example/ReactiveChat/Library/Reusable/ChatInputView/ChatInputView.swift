//
//  ChatInputView.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit
import SurfUtils

@IBDesignable
final class ChatInputView: UIView {

    typealias TextAction = (String) -> Void
    typealias EmptyClosure = () -> Void

    // MARK: - IBOutlets

    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var attachmentButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderView: UITextView!

    // MARK: - Inspectable

    @IBInspectable var maxLines: UInt = 6
    @IBInspectable var characterLimit: UInt = 1000

    @IBInspectable var placeholder: String {
        set {
            placeholderView.text = newValue
            configureTextStyles()
        }
        get {
            placeholderView.text
        }
    }

    @IBInspectable var text: String {
        set {
            textView.text = newValue
            updatePlaceholder(isVisibile: text.isEmpty)
            isLimitReached = newValue.count > characterLimit
        }
        get {
            textView.text
        }
    }

    // MARK: - IBActions

    @IBAction private func sendTapped(_ sender: Any) {
        guard !text.isEmpty else {
            return
        }
        onSendTapped?(text.trimWhitespacePrefix())
    }

    @IBAction private func attachmentTapped(_ sender: Any) {
        onAttachmentTapped?()
    }

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var topConstraint: NSLayoutConstraint! {
        didSet {
            topOffset = topConstraint.constant
        }
    }

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint! {
        didSet {
            bottomOffset = bottomConstraint.constant
        }
    }

    // MARK: - Private Properties

    private var topOffset: CGFloat = 0
    private var bottomOffset: CGFloat = 0

    private var lastNumberOfLines: UInt = 1

    private var isLimitReached = false {
        didSet {
            updateSendButton()
            configureTextStyles()
        }
    }

    // MARK: - Output

    var onTextChanged: TextAction?
    var onSendTapped: TextAction?
    var onAttachmentTapped: EmptyClosure?
    var onLimitReached: EmptyClosure?
    var onSizeChanged: EmptyClosure?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        textView.text = "Your text will be here"
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        if size.height == UIView.noIntrinsicMetric {
            // calculations of text height
            textView.layoutManager.glyphRange(for: textView.textContainer)
            size.height = textView.layoutManager.usedRect(for: textView.textContainer).height
                + textView.textContainerInset.top
                + textView.textContainerInset.bottom
        }

        let maxHeight = CGFloat(maxLines + 1) * (textView.font?.lineHeight ?? 0) + topOffset + bottomOffset

        let attributes = (UIStyle<UITextView>.chatInput as? StringAttributableStyle)?.attributes()
        let estimatedTextHeight = textView.text.height(withConstrainedWidth: textView.bounds.width,
                                                       attrs: attributes?.toDictionary() ?? [:])
        let estimatedNumberOfLines = UInt(estimatedTextHeight / 20)
        let exactNumberOfLines = textView.numberOfLines()
        let numberOfLines = max(estimatedNumberOfLines, exactNumberOfLines)

        if numberOfLines != lastNumberOfLines {
            onSizeChanged?()
        }

        if numberOfLines > maxLines {
            size.height = maxHeight
            if !textView.isScrollEnabled {
                textView.isScrollEnabled = true
                // queue in `main` to execute scrolling after layout updates
                DispatchQueue.main.async { [weak self] in
                    self?.textView.scrollToLastLine()
                }
            }
        } else if textView.isScrollEnabled {

            textView.isScrollEnabled = false

            if numberOfLines == maxLines {
                // to not miss last line
                size.height = maxHeight
            }
        }

        lastNumberOfLines = numberOfLines

        return size
    }

    // MARK: - Public Methods

    func clear() {
        isLimitReached = false
        text = ""
    }
}

// MARK: - UITextViewDelegate

extension ChatInputView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(text)
        updatePlaceholder(isVisibile: text.isEmpty)
        updateSendButton()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text else { return false }
        let canApply = textViewText.canApplyReplacement(with: range,
                                                        text: text,
                                                        characterLimit: Int(characterLimit))

        // to notify once
        if !canApply && !isLimitReached {
            onLimitReached?()
        }

        isLimitReached = !canApply

        // alow to enter text, but highlighting with red
        return true
    }

}

// MARK: - NSTextStorageDelegate

extension ChatInputView: NSTextStorageDelegate {

    func textStorage(_ textStorage: NSTextStorage,
                     didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange,
                     changeInLength delta: Int) {
        // Если delta большая значит вставляем текст
        guard delta > 1 else {
            return
        }
        invalidateIntrinsicContentSize()
    }

}

// MARK: - NSLayoutManagerDelegate

extension ChatInputView: NSLayoutManagerDelegate {

    func layoutManagerDidInvalidateLayout(_ sender: NSLayoutManager) {
        debugPrint("ChatInputView invalidate layout")
    }

}

// MARK: - Private

private extension ChatInputView {

    func configureAppearance() {

        backgroundColor = .white

        textView.isScrollEnabled = false
        placeholderView.isUserInteractionEnabled = false

        configureTextStyles()

        textView.tintColor = .rddm
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.showsHorizontalScrollIndicator = false

        placeholderView.textContainerInset = .zero
        placeholderView.textContainer.lineFragmentPadding = 0
        placeholderView.showsHorizontalScrollIndicator = false

        textView.delegate = self
        textView.layoutManager.delegate = self
        textView.textStorage.delegate = self

        updateSendButton()
    }

    func configureTextStyles() {
        if isLimitReached {
            invalidateIntrinsicContentSize()
            // queue in `main` to execute scrolling after layout updates
            DispatchQueue.main.async { [weak self] in
                self?.textView.apply(style: .chatInputError)
            }
        } else {
            textView.apply(style: .chatInput)
        }
        placeholderView.apply(style: .chatPlaceholder)

        textView.autocorrectionType = .default
        textView.spellCheckingType = .default
        textView.smartInsertDeleteType = .no
    }

    func updatePlaceholder(isVisibile: Bool) {
        invalidateIntrinsicContentSize()
        placeholderView.isHidden = !text.isEmpty
    }

    func updateSendButton() {
        let textInLimit = !isLimitReached
        let textIsNotEmpty = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        sendButton.isEnabled = textInLimit && textIsNotEmpty
    }
}
