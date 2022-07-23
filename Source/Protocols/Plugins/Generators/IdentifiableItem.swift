//
//  IdentifiableItem.swift
//  Pods
//
//  Created by porohov on 16.06.2022.
//

import Foundation

public protocol IdentifiableItem {

    /// Cell ID. Not every project may need an id, so its default value is optional
    var id: AnyHashable? { get }
}
