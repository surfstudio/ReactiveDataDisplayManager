//
//  BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit

public protocol BuilderContext {
    associatedtype ViewType: UIView
    associatedtype GeneratorType

    static func gen<Item: BaseItem>(_ type: Item.Type, model: Item.Model) -> GeneratorType
}
