//
//  DataDisplayConstructable.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Provide rddm property to simplify construction of generic generators
public protocol DataDisplayConstructable: AnyObject { }

extension DataDisplayConstructable {
    /// Gets a utils namespace holder for DataDisplay compatible types.
    public static var rddm: StaticDataDisplayWrapper<Self> {
        StaticDataDisplayWrapper()
    }
}
