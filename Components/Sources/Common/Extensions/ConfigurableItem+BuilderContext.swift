//
//  ConfigurableItem+BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

public extension ConfigurableItem where Self: RegistrationTypeProvider {

    static func build(in ctx: ViewContext.Type, with model: Model) -> BaseViewGenerator<Self> {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: TableContext.Type, with model: Model) -> BaseCellGenerator<Self> where Self: UITableViewCell {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: TableContext.Type, with model: Model) -> BaseCellGenerator<TableWrappedCell<Self>> {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: CollectionContext.Type, with model: Model) -> BaseCellGenerator<Self> where Self: UICollectionViewCell {
        ctx.gen(Self.self, model: model)
    }

    static func build(in ctx: CollectionContext.Type, with model: Model) -> BaseCellGenerator<CollectionWrappedCell<Self>> {
        ctx.gen(Self.self, model: model)
    }

}
