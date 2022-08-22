//
//  ResultChangeCellPosition.swift
//  Pods
//
//  Created by porohov on 16.06.2022.
//

import Foundation

/// Used in movable and drag'n'droppable plugins
public struct ResultChangeCellPosition {

    /// Cell id
    public let id: AnyHashable?

    /// Old cell index after move
    public let oldIndex: IndexPath

    /// New cell index after move
    public let newIndex: IndexPath
}
