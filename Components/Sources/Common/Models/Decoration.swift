//
//  Decoration.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 06.03.2023.
//

import UIKit

public enum Decoration {

    /// Base view to implement space between other views or cells.
    case space(model: SpacerView.Model)
    case divider(height: CGFloat, inset: UIEdgeInsets)
    case coloredDivider(color: UIColor, height: CGFloat, inset: UIEdgeInsets)
    case custom(generator: () -> UIView)

}
