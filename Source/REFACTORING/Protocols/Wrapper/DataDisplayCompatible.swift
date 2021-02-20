//
//  DataDisplayCompatible.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Provide rddm property to simplify building of collection manager
public protocol DataDisplayCompatible: AnyObject { }

extension DataDisplayCompatible {
    /// Gets a namespace holder for DataDisplay compatible types.
    public var rddm: DataDisplayWrapper<Self> {
        DataDisplayWrapper(self)
    }
}
