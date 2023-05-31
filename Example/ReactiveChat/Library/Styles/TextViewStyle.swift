//
//  TextViewStyle.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit
import SurfUtils

final class TextViewStyle: UIStyle<UITextView>, StringAttributableStyle {

    // MARK: - Private Properties

    let font: UIFont
    let textColor: UIColor
    let lineHeight: CGFloat
    let kern: CGFloat
    let alignment: NSTextAlignment
    let numberOfLines: Int
    let lineBreakMode: NSLineBreakMode
    let isEditable: Bool
    let showVerticalScroll: Bool

    // MARK: - Lifecycle

    init(font: UIFont,
         textColor: UIColor,
         lineHeight: CGFloat,
         kern: CGFloat,
         alignment: NSTextAlignment,
         numberOfLines: Int = 0,
         lineBreakMode: NSLineBreakMode = .byWordWrapping,
         isEditable: Bool,
         showVerticalScroll: Bool ) {
        self.font = font
        self.textColor = textColor
        self.lineHeight = lineHeight
        self.kern = kern
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        self.isEditable = isEditable
        self.showVerticalScroll = showVerticalScroll
    }

    // MARK: - UIStyle

    override func apply(for view: UITextView) {
        let attrs: [StringAttribute] = [
            .lineHeight(lineHeight),
            .kern(kern),
            .foregroundColor(textColor),
            .aligment(alignment),
            .lineBreakMode(.byWordWrapping)
        ]
        view.font = font
        view.textColor = textColor
        view.isEditable = isEditable
        view.autocorrectionType = .no
        view.showsVerticalScrollIndicator = showVerticalScroll
        view.attributedText = view.text?.with(attributes: attrs)
        view.textContainer.maximumNumberOfLines = numberOfLines
        view.textContainer.lineBreakMode = lineBreakMode
        view.removeUndoRedoOptions()
    }

    // MARK: - AttributableStyle

    func attributes() -> [StringAttribute] {
        [
            .lineHeight(lineHeight),
            .kern(kern),
            .foregroundColor(textColor),
            .aligment(alignment),
            .lineBreakMode(lineBreakMode)
        ]
    }

}
