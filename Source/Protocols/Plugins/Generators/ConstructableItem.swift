//
//  ConstructableItem.swift
//  Pods
//
//  Created by Никита Коробейников on 15.12.2021.
//

/// Identify availability of constracting cell without  `dequeueReusableCell`
public protocol ConstractableItem {

    /// Enum with different types of constructing cells for `nonReusable` generator
    /// - xib - init from paired `.xib` file
    /// - manual - init from code
    static var constructionType: ConstructionType { get }

}
