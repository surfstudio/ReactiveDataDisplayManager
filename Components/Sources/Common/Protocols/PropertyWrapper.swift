//
//  PropertyWrapper.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import Foundation

public protocol PropertyWrapper {

    associatedtype Property: Editor

    static func create() -> Property.Model

}

// MARK: - Defaults

public extension PropertyWrapper where Property.Model == Self {

    static func build(@EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
        return content(Property.self).reduce(Self.create(), { model, editor in
            editor.edit(model)
        })
    }

}
