//
//  TextValue.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public enum TextValue: Equatable {
    case string(String)
    /// Keep in mind that attributed string may re-configure other model's properties.
    case attributedString(NSAttributedString)
}

// MARK: - Defaults

public extension TextValue {

    func apply(in view: UILabel) {
        switch self {
        case .string(let string):
            view.text = string
        case .attributedString(let attributedString):
            view.attributedText = attributedString
        }
    }

    func apply(in view: UITextView) {
        switch self {
        case .string(let string):
            view.text = string
        case .attributedString(let attributedString):
            view.attributedText = attributedString
        }
    }

}
