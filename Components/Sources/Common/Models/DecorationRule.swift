//
//  DecorationRule.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 06.03.2023.
//

/// Rule used to decorate array of generators with decorations
public enum DecorationRule {

    /// insert some decoration to each item
    case each
    /// insert some decoration to first item
    case first
    /// insert some decoration to last item
    case last
    /// custom implementation of `Decorator`
    case custom(Decorator)

}
