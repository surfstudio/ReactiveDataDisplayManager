//
//  UIStyle+UITextView.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit
import SurfUtils

// MARK: - Apply

extension UITextView {
    func apply(style: UIStyle<UITextView>) {
        style.apply(for: self)
    }
}

// MARK: - Styles

extension UIStyle {

    static var chatInput: UIStyle<UITextView> {
        return TextViewStyle(font: UIFont.systemFont(ofSize: 14),
                             textColor: .black,
                             lineHeight: 20,
                             kern: -0.24,
                             alignment: .left,
                             isEditable: true,
                             showVerticalScroll: true)
    }

    static var chatInputError: UIStyle<UITextView> {
        return TextViewStyle(font: UIFont.systemFont(ofSize: 14),
                             textColor: .red,
                             lineHeight: 20,
                             kern: -0.24,
                             alignment: .left,
                             isEditable: true,
                             showVerticalScroll: true)
    }

    static var chatPlaceholder: UIStyle<UITextView> {
        return TextViewStyle(font: UIFont.systemFont(ofSize: 14),
                             textColor: .lightGray,
                             lineHeight: 20,
                             kern: -0.24,
                             alignment: .left,
                             isEditable: false,
                             showVerticalScroll: false)
    }

}

// MARK: - Layout transformators

extension UIStyle where Control == UITextView {

    /// Modifiyng style with limiting to `numberOfLines` and  setting `lineBreakMode`
    func lines(_ numberOfLines: Int, with lineBreakMode: NSLineBreakMode) -> UIStyle<UITextView> {
        guard let style = self as? TextViewStyle else {
            return self
        }
        return TextViewStyle(font: style.font,
                             textColor: style.textColor,
                             lineHeight: style.lineHeight,
                             kern: style.kern,
                             alignment: style.alignment,
                             numberOfLines: numberOfLines,
                             lineBreakMode: lineBreakMode,
                             isEditable: style.isEditable,
                             showVerticalScroll: style.showVerticalScroll)
    }
}
