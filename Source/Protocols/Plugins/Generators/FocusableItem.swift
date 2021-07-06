// 
//  FocusableItem.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//

#if os(tvOS)
import UIKit

public protocol FocusableItem {

    func canBeFocused() -> Bool
}

public extension FocusableItem {

    func canBeFocused() -> Bool {
        return true
    }

}
#endif
