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
    let duration: TimeInterval
    let delay: TimeInterval

    /// Takes parameters
    /// - Parameters:
    ///     - transform:  defaul value nil
    ///     - transform:  defaul value CGSize(width: 0, height: 0)
    ///     - delay: default value .zero
    public init(
        transform: CGAffineTransform,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = .zero
    ) {
        self.transform = transform
        self.duration = duration
        self.delay = delay
    }
}
