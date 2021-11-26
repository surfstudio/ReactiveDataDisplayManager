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
    let align: FocusableAlign?
    let border: FocusablePlaginBorderModel?

    /// Takes parameters
    /// - Parameters:
    ///     - transform:  defaul value nil
    ///     - transformDuration:  defaul value CGSize(width: 0, height: 0)
    ///     - shadow:  defaul value nil
    ///     - align: defaults to nil
    public init(
        transform: CGAffineTransform? = nil,
        transformDuration: CGFloat = 0.5,
        shadow: FocusedPlaginShadowModel? = nil,
        align: FocusableAlign? = nil,
        border: FocusablePlaginBorderModel? = nil
    ) {
        self.transform = transform
        self.shadow = shadow
        self.transformDuration = transformDuration
        self.align = align
        self.border = border
    }
}

/// Model for configure UIView shadow
public struct FocusedPlaginShadowModel {
    let color: UIColor
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
        self.color = color
        self.offset = offset
        self.opacity = opacity
        self.radius = radius
    }
}

/// Model for configure UIView border
public struct FocusablePlaginBorderModel {
    let color: UIColor
    let width: CGFloat
    let radius: CGFloat
    let clipsToBounds: Bool

    /// Takes parameters
    /// - Parameters:
    ///     - color: UIColor
    ///     - width:  defaul value 3
    ///     - radius:  defaul value 10
    ///     - clipsToBounds:  default value false
    public init(
        color: UIColor,
        width: CGFloat = 3,
        radius: CGFloat = 10,
        clipsToBounds: Bool = false
    ) {
        self.color = color
        self.width = width
        self.radius = radius
        self.clipsToBounds = clipsToBounds
    }
}

/// Configure focusable align
public enum FocusableAlign {
    case left, right, center
}
