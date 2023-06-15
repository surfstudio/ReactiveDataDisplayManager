//
//  Editor.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.06.2023.
//

import Foundation

public protocol Editor {
    associatedtype Model

    func edit(_ model: Model) -> Model
}

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
        Array(components.joined())
    }

    // to use like if else

    public static func buildEither(first component: T) -> T {
        return component
    }

    public static func buildEither(second component: T) -> T {
        return component
    }
}
