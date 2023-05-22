//
//  DecorationProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

public protocol DecorationProvider {

    associatedtype GeneratorType: IdentifiableItem

    func provideDecoration(with parentId: AnyHashable) -> GeneratorType

}
