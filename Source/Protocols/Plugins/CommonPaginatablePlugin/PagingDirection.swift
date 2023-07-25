//
//  PagingDirection.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 20.07.2023.
//

import Foundation

public enum PagingDirection {

    public enum ForwardDirection {
        case bottom, right
    }

    public enum BackwardDirection {
        case top, left
    }

    case backward(BackwardDirection)
    case forward(ForwardDirection)

    var isBackward: Bool {
        switch self {
        case .backward:
            return true
        case .forward:
            return false
        }
    }

}
