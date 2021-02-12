//
//  TableBatchUpdatesAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// UITableView Animator based on performBatchUpdates
@available(iOS 11, *)
public class TableBatchUpdatesAnimator: Animator<UITableView> {

    public override func perform(in collection: UITableView, animation: () -> Void) {
        collection.performBatchUpdates(animation)
    }

}
