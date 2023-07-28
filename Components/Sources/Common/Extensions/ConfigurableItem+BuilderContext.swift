//
//  ConfigurableItem+BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

public extension ConfigurableItem where Self: RegistrationTypeProvider {

    static func build(in ctx: ViewContext.Type, with model: Model) -> ViewContext.GeneratorType {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: TableContext.Type, with model: Model) -> TableContext.GeneratorType where Self: UITableViewCell {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: TableContext.Type, with model: Model) -> TableContext.GeneratorType {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: TableContext.Type, with model: Model) -> TableContext.GeneratorType where Self: UICollectionViewCell {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: CollectionContext.Type, with model: Model) -> CollectionContext.GeneratorType {
        ctx.gen(Self.self, model: model)
    }

}
