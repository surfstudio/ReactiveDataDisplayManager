//
//  ConfigurableItem+BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

public extension ConfigurableItem where Self: RegistrationTypeProvider {

    /// This method is used to build generator for some `UIView` which can be used as child for `StackView`
    ///  - Parameters:
    ///   - ctx: may be `ViewContext.self`
    ///   - model: configurable model for `UIView`
    static func build(in ctx: ViewContext.Type, with model: Model) -> BaseViewGenerator<Self> {
        ctx.gen(Self.self, model: model)
    }

    /// This method is used to build generator for some `UITableViewCell` to place it in `UITableView`
    ///  - Parameters:
    ///     - ctx: may be `TableContext.self`
    ///      - model: configurable model for `UITableViewCell`
    static func build(in ctx: TableContext.Type, with model: Model) -> BaseCellGenerator<Self> where Self: UITableViewCell {
        ctx.gen(Self.self, model: model)
    }

    /// This method is used to build generator for some `UIView` wrapped in `TableWrappedCell` to place it in `UITableView`
    ///  - Parameters:
    ///     - ctx: may be `TableContext.self`
    ///     - model: configurable model for `UIView`
    static func build(in ctx: TableContext.Type, with model: Model) -> BaseCellGenerator<TableWrappedCell<Self>> {
        ctx.gen(Self.self, model: model)
    }

    /// This method is used to build generator for some `UICollectionViewCell` to place it in `UICollectionView`
    ///  - Parameters:
    ///     - ctx: may be `CollectionContext.self`
    ///     - model: configurable model for `UIView`
    static func build(in ctx: CollectionContext.Type, with model: Model) -> BaseCellGenerator<Self> where Self: UICollectionViewCell {
        ctx.gen(Self.self, model: model)
    }

    /// This method is used to build generator for some `UIView` wrapped in `CollectionWrappedCell` to place it in `UICollectionView`
    ///  - Parameters:
    ///     - ctx: may be `CollectionContext.self`
    ///     - model: configurable model for `UIView`
    static func build(in ctx: CollectionContext.Type, with model: Model) -> BaseCellGenerator<CollectionWrappedCell<Self>> {
        ctx.gen(Self.self, model: model)
    }

}
