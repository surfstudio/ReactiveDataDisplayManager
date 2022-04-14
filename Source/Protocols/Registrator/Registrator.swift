//
//  Registrator.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

/// Helper class to register cells/headers/footers
open class Registrator<View: UIView> {

    public private(set) weak var view: View!

    private var cache: Set<String> = Set<String>()

    /// - parameter view: View which contains subviews or cells
    public init(view: View) {
        self.view = view
    }

    open func register(item: RegisterableItem, with view: View) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Register If needed
    public func registerIfNeeded(item: RegisterableItem, with view: View) {
        guard canRegister(item: item) else {
            return
        }
        register(item: item, with: view)
        put(item: item)
    }
}

// MARK: - Private

private extension Registrator {

    func canRegister(item: RegisterableItem) -> Bool {
        !cache.contains(item.descriptor)
    }

    func put(item: RegisterableItem) {
        cache.update(with: item.descriptor)
    }

}
