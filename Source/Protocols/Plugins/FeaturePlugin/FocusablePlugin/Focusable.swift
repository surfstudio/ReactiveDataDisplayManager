// 
//  Focusable.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  
//

#if os(tvOS)

import Foundation
import UIKit

public protocol Focusable {
    associatedtype DelegateType: FocusableDelegate

    var delegate: DelegateType { get set }
}

public protocol FocusableDelegate {
    associatedtype Provider: GeneratorsProvider

    /// Asks whether the item at the specified index path can be focused
    /// - parameters:
    ///     - at: index path of the focused item
    ///     - with: current provider with generators
    func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool
}

#endif
