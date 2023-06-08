//
//  Alignment.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import UIKit

/// Alignment of `nestedView` inside `ViewWrapper`
public enum Alignment: Equatable {

    /// same as `TrailingLessThenOrEqual` and `Equal` for all other constraints
    case leading(UIEdgeInsets)
    /// same as `LeadingGreaterThenOrEqual` and `Equal` for all other constraints
    case trailing(UIEdgeInsets)
    /// same as `Equal` for all `[top, bottom, leading, trailing]` constraints
    case all(UIEdgeInsets)

}
