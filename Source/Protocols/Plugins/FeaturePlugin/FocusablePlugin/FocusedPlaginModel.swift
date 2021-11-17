//
//  FocusedPlaginModel.swift
//  Pods
//
//  Created by porohov on 17.11.2021.
//

import Foundation

struct FocusedPlaginModel {
    let transform: (previus: CGAffineTransform, next: CGAffineTransform)? = nil
    let shadow: FocusedPlaginShadowModel? = nil
}

struct FocusedPlaginShadowModel {
    let color: CGColor
    let offset: CGSize = CGSize(width: 0, height: 0)
    let opacity: Float = 0.9
    let radius: CGFloat = 10.0
}
