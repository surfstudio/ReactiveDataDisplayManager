//
//  CollectionScrollProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol CollectionScrollProvider {
    func setBeginDraggingOffset(_ contentOffsetX: CGFloat)
    func setTargetContentOffset(_ targetContentOffset: UnsafeMutablePointer<CGPoint>, for scrollView: UIScrollView)
}
