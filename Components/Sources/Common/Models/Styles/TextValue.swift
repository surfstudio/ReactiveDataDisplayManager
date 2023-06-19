//
//  TextValue.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public enum TextValue: Equatable {
    case string(String)
    /// Keep in mind that attributed string may re-configure other model's properties.
    case attributedString(NSAttributedString)
}
