//
//  CollectionBatchUpdatesAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 24.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// UICollectionView Animator based on performBatchUpdates
public class CollectionBatchUpdatesAnimator: Animator<UICollectionView> {

    public override func performAnimated(in collection: UICollectionView, operation: Operation?) {
        collection.performBatchUpdates(operation ?? { })
    }

}
