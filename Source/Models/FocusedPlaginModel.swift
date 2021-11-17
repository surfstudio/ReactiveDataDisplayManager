//
//  FocusedPlaginModel.swift
//  Pods
//
//  Created by porohov on 17.11.2021.
//

import UIKit

/// Model for FocusablePlugin
public struct FocusedPlaginModel {
    let transform: CGAffineTransform?
    let transformDuration: CGFloat
    let shadow: FocusedPlaginShadowModel?
    let center: Bool

    /// Takes parameters
    /// - Parameters:
    ///     - transform:  defaul value nil
    ///     - transformDuration:  defaul value CGSize(width: 0, height: 0)
    ///     - shadow:  defaul value nil
    ///     - center: centers the selected cell, defaults to false
    public init(transform: CGAffineTransform? = nil,
                transformDuration: CGFloat = 0.5,
                shadow: FocusedPlaginShadowModel? = nil,
                center: Bool = false) {
        self.transform = transform
        self.shadow = shadow
        self.transformDuration = transformDuration
        self.center = center
    }
}

/// Model for configure UIView shadow
public struct FocusedPlaginShadowModel {
    let color: CGColor
    let offset: CGSize
    let opacity: Float
    let radius: CGFloat

    /// Takes parameters
    /// - Parameters:
    ///     - color: UIColor
    ///     - offset:  defaul value CGSize(width: 0, height: 0)
    ///     - opacity:  defaul value 0.9
    ///     - radius:  default value 10.0
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
