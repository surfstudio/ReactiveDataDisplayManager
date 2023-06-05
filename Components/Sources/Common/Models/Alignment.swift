//
//  Alignment.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import UIKit

/// Alignment of `nestedView` inside `ViewWrapper`
public enum Alignment {

    /// same as `TrailingLessThenOrEqual` and `Equal` for all other constraints
    case leading
    /// same as `LeadingGreaterThenOrEqual` and `Equal` for all other constraints
    case trailing

}
