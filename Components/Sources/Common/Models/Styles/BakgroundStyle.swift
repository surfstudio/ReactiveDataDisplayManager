//
//  BakgroundStyle.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public enum BackgroundStyle: Equatable {

    /// Solid background filled with single color
    case solid(UIColor?)

    // TODO: - gradient, image, bezierPath, bordered

}

// MARK: - Defaults

public extension BackgroundStyle {

    func apply(in view: UIView) {
        switch self {
        case .solid(let color):
            view.backgroundColor = color
        }
    }

}

public extension Optional<BackgroundStyle> {

    func apply(in view: UIView) {
        if let self {
            self.apply(in: view)
        } else {
            view.backgroundColor = nil
        }
    }

}
