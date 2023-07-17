//
//  TableRowAnimation.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 26.06.2023.
//

import UIKit

public enum TableRowAnimation {
    case animated(UITableView.RowAnimation)
    case notAnimated

    var value: UITableView.RowAnimation? {
        switch self {
        case .animated(let animation):
            return animation
        case .notAnimated:
            return nil
        }
    }
}

public enum TableRowAnimationGroup {
    case animated(UITableView.RowAnimation, UITableView.RowAnimation)
    case notAnimated

    var value: (UITableView.RowAnimation, UITableView.RowAnimation)? {
        switch self {
        case .animated(let left, let right):
            return (left, right)
        case .notAnimated:
            return nil
        }
    }
}
