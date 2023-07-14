//
//  ConfigurableItem+Builder.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 06.07.2023.
//

import ReactiveDataDisplayManager

public extension ConfigurableItem {

    static func buildView(with model: Self.Model, and type: CellRegisterType = .nib) -> Self {
        let cell: Self?
        switch type {
        case .nib:
            cell = Self.loadFromNib(bundle: Self.bundle() ?? .main) as? Self
        case .class:
            cell = Self()
        }
        guard let cell = cell else {
            fatalError("Can't load cell \(Self.self)")
        }
        cell.configure(with: model)
        return cell
    }

}

@resultBuilder
public enum ConfigurableItemBuilder {

    public static func buildExpression(_ expression: any ConfigurableItem) -> [any ConfigurableItem] {
        return [expression]
    }

    public static func buildExpression(_ expressions: [any ConfigurableItem]) -> [any ConfigurableItem] {
        return expressions
    }

    public static func buildExpression(_ expression: ()) -> [any ConfigurableItem] {
        return []
    }

    public static func buildBlock(_ components: [any ConfigurableItem]...) -> [any ConfigurableItem] {
        return components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[any ConfigurableItem]]) -> [any ConfigurableItem] {
        Array(components.joined())
    }

}
