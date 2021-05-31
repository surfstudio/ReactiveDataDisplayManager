//
//  Collection+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

extension UICollectionView: DataDisplayCompatible { }

public extension DataDisplayWrapper where Base: UICollectionView {

    /// Builder of `BaseCollectionManager`
    var baseBuilder: CollectionBuilder<BaseCollectionManager> {
        CollectionBuilder(view: base, manager: BaseCollectionManager())
    }

}
