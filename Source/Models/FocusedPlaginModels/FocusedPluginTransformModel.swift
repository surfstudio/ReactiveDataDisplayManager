//
//  FocusedPluginTransformModel.swift
//  Pods
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Model for configure UIView transform
public struct FocusedPluginTransformModel {
    let transform: CGAffineTransform
    let duration: CGFloat
    let delay: CGFloat

    /// Takes parameters
    /// - Parameters:
    ///     - transform:  defaul value nil
    ///     - transformDuration:  defaul value CGSize(width: 0, height: 0)
    public init(
        transform: CGAffineTransform,
        duration: CGFloat = 0.5,
        delay: TimeInterval = .zero
    ) {
        self.transform = transform
        self.duration = duration
        self.delay = delay
    }
}
