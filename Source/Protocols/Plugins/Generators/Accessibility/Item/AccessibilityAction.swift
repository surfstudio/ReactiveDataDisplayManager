//
//  AccessibilityAction.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 17.07.2023.
//

import Foundation
import UIKit

public struct AccessibilityAction {

    // MARK: - Properties

    let name: String
    let action: UIAccessibilityCustomAction

    // MARK: - Initializers

    /// Closure based `UIAcessibilityCustomAction`
    /// - Warning: available only for iOS 13 and higher
    /// - Parameters:
    ///    - name: name of action
    ///    - handler: closure that will be called when action will be triggered
    @available(iOS 13.0, tvOS 13.0, *)
    public static func closure(name: String, handler: (() -> Void)?) -> AccessibilityAction {
        .init(name: name,
              action: .init(name: name,
                            actionHandler: { _ in
            handler?()
            return true
        }))
    }

    /// Selector based `UIAcessibilityCustomAction`
    /// - Parameters:
    ///   - name: name of action
    ///   - target: target of selector
    ///   - selector: selector that will be called when action will be triggered
    public static func selector(name: String, target: Any?, selector: Selector) -> AccessibilityAction {
        .init(name: name,
              action: .init(name: name,
                            target: target,
                            selector: selector))
    }

}
