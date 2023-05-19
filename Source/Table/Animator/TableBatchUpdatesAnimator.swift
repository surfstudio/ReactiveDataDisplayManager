//
//  TableBatchUpdatesAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// UITableView Animator based on performBatchUpdates
@available(iOS 11.0, tvOS 11.0, *)
public class TableBatchUpdatesAnimator: Animator<UITableView> {

    public override func performAnimated(in collection: UITableView, operation: Operation?) {
        collection.performBatchUpdates(operation ?? { })
    }

}
