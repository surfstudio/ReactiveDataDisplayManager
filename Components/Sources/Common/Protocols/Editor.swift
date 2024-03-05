//
//  Editor.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.06.2023.
//

import Foundation

// MARK: - Protocols

public protocol Editor {
    associatedtype Model

    func edit(_ model: Model) -> Model
}

public protocol EditorWrapper {

    associatedtype Property: Editor

    static func create() -> Property.Model

}

// MARK: - Builder

@resultBuilder
public struct EditorBuilder<T: Editor> {
    public static func buildExpression(_ expression: T) -> [T] {
        return [expression]
    }

    public static func buildExpression(_ expressions: [T]) -> [T] {
        return expressions
    }

    public static func buildExpression(_ expression: ()) -> [T] {
        return []
    }

    public static func buildBlock(_ components: [T]...) -> [T] {
        return components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[T]]) -> [T] {
        return Array(components.joined())
    }

    // to use like if-else

    public static func buildEither(first component: [T]) -> [T] {
        return component
    }

    public static func buildEither(second component: [T]) -> [T] {
        return component
    }

    public static func buildOptional(_ component: [T]?) -> [T] {
        return component ?? []
    }
}

// MARK: - Shortcut

public extension EditorWrapper where Property.Model == Self {

    static func build(@EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
        return content(Property.self).reduce(Self.create(), { model, editor in
            editor.edit(model)
        })
    }

}
