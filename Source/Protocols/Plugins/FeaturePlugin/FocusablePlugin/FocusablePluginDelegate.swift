// 
//  FocusablePluginDelegate.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  

#if os(tvOS)
import Foundation
import UIKit

open class FocusablePluginDelegate<Provider: GeneratorsProvider> {

    // MARK: - Typealias

    public typealias GeneratorType = FocusableItem

}

// MARK: - MovableDelegate

extension FocusablePluginDelegate: FocusableDelegate {

    open func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canBeFocused()
        }
        return false
    }

}

#endif
