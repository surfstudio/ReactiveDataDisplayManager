//
//  Decorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

public protocol Decorator {

    func insert(decoration: Decoration, to items: [IdOwner], at anchor: DecorationAnchor) -> [IdOwner]

}
