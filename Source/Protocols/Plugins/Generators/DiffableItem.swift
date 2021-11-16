//
//  DiffableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit
import Foundation

/// Protocol to wrap `DiffableItem`
public protocol DiffableItemSource {
    var diffableItem: DiffableItem { get }
}

/// Wrapper of id and equatable state of model
public class DiffableItem: NSObject {

    // MARK: - Properties

    /// `Unique `identifier to hashKey
    public var id: String

    /// `Equatable` state of model,
    public var state: AnyEquatable

    // MARK: - Initialization

    /// - parameter id: `Unique `identifier to hashKey
    /// - parameter state: `Equatable` state of model,
    public init(id: String, state: AnyEquatable) {
        self.id = id
        self.state = state
    }

    // MARK: - Hashable

    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableItem else { return false }
        return id == object.id && state == object.state
    }

}
