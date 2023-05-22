//
//  DecorationRule+Decorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

extension DecorationRule {

    /// Decorator resolved based on `DecorationRule`
    private var resolvedDecorator: Decorator {
        switch self {
        case .each:
            return EachItemDecorator()
        case .first:
            return FirstItemDecorator()
        case .last:
            return LastItemDecorator()
        case .custom(let decorator):
            return decorator
        }
    }

    /// Wrapping of decorator with safe `NonEmptyDecorator`
    var decorator: Decorator {
        NonEmptyDecorator(decorator: resolvedDecorator)
    }

}
