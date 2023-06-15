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
