//
//  SwipeableTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SPMCustomTableGenerator: BaseCellGenerator<SPMExampleTableViewCell>, SwipeableItem {

    // MARK: - SwipeableItem

    var didSwipeEvent = BaseEvent<String>()
    var actionTypes = [String]()

}
