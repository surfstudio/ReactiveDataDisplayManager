//
//  PrefetcherableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol PrefetcherableItem: class {
    associatedtype IdType: Hashable

    var requestId: IdType? { get }
}
