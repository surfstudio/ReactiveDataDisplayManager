//
//  FocusablePluginBorderModel.swift
//  Pods
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Model for configure UIView border
public struct FocusablePluginBorderModel {
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
