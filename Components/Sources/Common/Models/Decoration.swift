//
//  Decoration.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 06.03.2023.
//

import UIKit

public enum Decoration {

    /// empty cell with concrete `height`
    case space(height: CGFloat)
    case divider(height: CGFloat, inset: UIEdgeInsets)
    case coloredSpace(color: UIColor, height: CGFloat)
    case coloredDivider(color: UIColor, height: CGFloat, inset: UIEdgeInsets)
    case custom(generator: () -> UIView)

}
