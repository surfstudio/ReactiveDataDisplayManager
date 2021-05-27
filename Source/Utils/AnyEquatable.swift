//
//  AnyEquatable.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 10.03.2021.
//

import Foundation

/// Type erasure for `Equatable`
public struct AnyEquatable {
    private let isEqualTo: (AnyEquatable) -> Bool
    let equatable: Any

    public init<T: Equatable>(_ equatable: T) {
        self.equatable = equatable
        self.isEqualTo = { anotherEquatable in
            guard let anotherEquatable = anotherEquatable.equatable as? T else {
                return false
            }

            return anotherEquatable == equatable
        }
    }
}

extension AnyEquatable: Equatable {
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.isEqualTo(rhs)
    }
}
