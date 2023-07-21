//
//  ViewSize.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public enum ViewSize: Equatable {
    case height(CGFloat)
    case width(CGFloat)
    case size(CGSize)

    // MARK: - Properties

    var height: CGFloat {
        switch self {
        case .size(let size):
            return size.height
        case .height(let height):
            return height
        case .width:
            return 0
        }
    }

    var width: CGFloat {
        switch self {
        case .size(let size):
            return size.width
        case .height:
            return 0
        case .width(let width):
            return width
        }
    }

    // MARK: - Methods

    func applyTo(heightConstraint: NSLayoutConstraint?, widthConstraint: NSLayoutConstraint?) {
        switch self {
        case .height(let height):
            heightConstraint?.constant = height
            heightConstraint?.isActive = true
            widthConstraint?.isActive = false

        case .width(let width):
            widthConstraint?.constant = width
            widthConstraint?.isActive = true
            heightConstraint?.isActive = false

        case .size(let size):
            heightConstraint?.constant = size.height
            heightConstraint?.isActive = true
            widthConstraint?.constant = size.width
            widthConstraint?.isActive = true
        }
    }
}
