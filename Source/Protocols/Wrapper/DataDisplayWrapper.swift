//
//  DataDisplay.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Wrap Base instance for easy access
public struct DataDisplayWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

// Wrap Base type for easy access
public struct StaticDataDisplayWrapper<Base> { }
