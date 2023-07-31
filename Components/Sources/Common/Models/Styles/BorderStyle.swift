//
//  BorderStyle.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public struct BorderStyle: Equatable {

    public let cornerRadius: CGFloat
    public let maskedCorners: CACornerMask
    public let borderWidth: CGFloat
    public let borderColor: CGColor

    public init(cornerRadius: CGFloat,
                maskedCorners: CACornerMask,
                borderWidth: CGFloat = 0,
                borderColor: CGColor = UIColor.clear.cgColor) {
        self.cornerRadius = cornerRadius
        self.maskedCorners = maskedCorners
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }

}

// MARK: - Defaults

public extension BorderStyle {

    func apply(in view: UIView) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.layer.maskedCorners = maskedCorners
    }

}

public extension Optional<BorderStyle> {

    func apply(in view: UIView) {
        if let self {
            self.apply(in: view)
        } else {
            view.layer.cornerRadius = 0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.borderWidth = 0
            view.layer.maskedCorners = .init()
        }
    }

}
