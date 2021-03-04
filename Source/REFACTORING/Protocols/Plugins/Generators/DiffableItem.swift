//
//  DiffableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit
import Foundation

public protocol DiffableItemSource {
    var item: DiffableItem { get }
}

/// All diffable cells and headers should include this item
open class DiffableItem: NSObject {

    // MARK: - Properties

    public var identifier: String

    // MARK: - Initialization

    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - Public Methods

    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(identifier)
        return hasher.finalize()
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableItem else { return false }
        return identifier == object.identifier
    }

}
