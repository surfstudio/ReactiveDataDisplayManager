//
//  AccessibilityParser.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

struct AccessibilityItemInfo {
    var accessibilityElements: [NSObject]

    var containsAction: Bool {
        accessibilityElements.contains(where: { $0 is UIButton })
    }

    var isEmpty: Bool {
        accessibilityElements.isEmpty
    }
}

enum AccessibilityParser {
    static func process(view: UIView) -> AccessibilityItemInfo {
        if view.isAccessibilityElement {
            return AccessibilityItemInfo(accessibilityElements: [view])
        } else if view.subviews.isEmpty {
            return AccessibilityItemInfo(accessibilityElements: [])
        }

        var accessibilityElements = view.subviews.filter(\.isAccessibilityElement) as [NSObject]
        if accessibilityElements.isEmpty {
            accessibilityElements = view.subviews.flatMap { process(view: $0).accessibilityElements }
        }
        return AccessibilityItemInfo(accessibilityElements: accessibilityElements)
    }

    static func apply(info: AccessibilityItemInfo, to view: UIView) {
        guard !info.isEmpty else {
            view.isAccessibilityElement = false
            return
        }
        view.isAccessibilityElement = true

        if let element = info.accessibilityElements.first {
            view.accessibilityLabel = element.accessibilityLabel
            view.accessibilityValue = element.accessibilityValue
            view.accessibilityTraits = element.accessibilityTraits
        }
        if let subElement = info.accessibilityElements[safe: 1] {
            view.accessibilityValue = subElement.accessibilityLabel
        }
    }

    static func processAndApply(process view: UIView, applyTo viewToApply: UIView) {
        let info = process(view: view)
        apply(info: info, to: viewToApply)
    }
}
