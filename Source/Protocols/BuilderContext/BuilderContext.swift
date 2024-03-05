//
//  BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit

/// Context which is used to build `UIView` in some container view which can be on of: `UIStackView`, `UICollectionView`, `UITableView`
public protocol BuilderContext {
    /// Base type of child view
    associatedtype ViewType: UIView
}
