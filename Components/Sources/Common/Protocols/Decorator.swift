//
//  Decorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

public protocol Decorator {

    func insert(decoration: any DecorationProvider, to items: [DiffableItemSource], at anchor: DecorationAnchor) -> [DiffableItemSource]

}
