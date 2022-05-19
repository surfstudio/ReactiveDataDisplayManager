//
//  SectionsType.swift
//  Pods
//
//  Created by Konstantin Porokhov on 11.11.2021.
//

import Foundation

// sourcery: AutoMockable
/// Allow dragging cells according to strategy
protocol StrategyDropable {
    /// The method defines the strategy for the drag and drop behavior.
    /// - parameters:
    ///     - source:  Source IndexPath
    ///     - destination: Destination IndexPath
    /// - returns: Returns a Bool value
    func canDrop(from source: IndexPath, to destination: IndexPath) -> Bool
}

public enum DropStrategy: StrategyDropable {

    /// Allow drop item from any to any
    case all
    /// Allow drop item only inside current section
    case current

    /// The method defines the strategy for the drag and drop behavior.
    /// - Returns: true if - case all;  - case current and source.section equal destination.section
    func canDrop(from source: IndexPath, to destination: IndexPath) -> Bool {
        switch self {
        case .all: return true
        case .current: return source.section == destination.section
        }
    }

}
