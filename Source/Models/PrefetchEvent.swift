//
//  PrefetchEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public enum PrefetchEvent {
    case prefetch([IndexPath])
    case cancelPrefetching([IndexPath])
}
