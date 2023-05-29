//
//  TableUpdatesAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// UITableView Animator based on beginUpdates and endUpdates
public class TableUpdatesAnimator: Animator<UITableView> {

    public override func performAnimated(in collection: UITableView, operation: Operation?) {
        collection.beginUpdates()
        operation?()
        collection.endUpdates()
    }

}
