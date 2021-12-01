//
//  FocusedPluginShadowModel.swift
//  Pods
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Model for configure UIView shadow
public struct FocusedPluginShadowModel {
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
