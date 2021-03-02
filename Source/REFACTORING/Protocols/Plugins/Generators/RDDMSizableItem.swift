//
//  RDDMSizableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Generator that describes collection cell generator that can returns size
public protocol RDDMSizableItem: class {
    func getSize() -> CGSize
}
