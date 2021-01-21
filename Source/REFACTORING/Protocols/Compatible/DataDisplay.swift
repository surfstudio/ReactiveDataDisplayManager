//
//  DataDisplay.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public struct DataDisplayWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DataDisplayCompatible: AnyObject { }

extension DataDisplayCompatible {
    /// Gets a namespace holder for DataDisplay compatible types.
    public var rddm: DataDisplayWrapper<Self> {
        get { return DataDisplayWrapper(self) }
        set { }
    }
}
