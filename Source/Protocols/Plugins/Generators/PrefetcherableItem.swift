//
//  PrefetcherableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to provide prefetching content
public protocol PrefetcherableItem: AnyObject {
    associatedtype IdType: Hashable

    /// Unique (in list) request for prefetching.
    ///
    /// For example: `URL` of image.
    var requestId: IdType? { get }
}
