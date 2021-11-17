//
//  FocusedPlaginModel.swift
//  Pods
//
//  Created by porohov on 17.11.2021.
//

import UIKit

public struct FocusedPlaginModel {
    let transform: CGAffineTransform?
    let transformDuration: CGFloat?
    let shadow: FocusedPlaginShadowModel?

    public init(transform: CGAffineTransform? = nil,
                transformDuration: CGFloat? = 0.5,
                shadow: FocusedPlaginShadowModel? = nil) {
        self.transform = transform
        self.shadow = shadow
        self.transformDuration = transformDuration
    }
}

public struct FocusedPlaginShadowModel {
    let color: CGColor
    let offset: CGSize
    let opacity: Float
    let radius: CGFloat

    public init(
        color: UIColor,
        offset: CGSize = CGSize(width: 0, height: 0),
        opacity: Float = 0.9,
        radius: CGFloat = 10.0
    ) {
        self.color = color.cgColor
        self.offset = offset
        self.opacity = opacity
        self.radius = radius
    }
    
}
