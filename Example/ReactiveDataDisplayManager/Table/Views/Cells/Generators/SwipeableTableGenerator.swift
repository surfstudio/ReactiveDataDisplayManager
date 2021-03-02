//
//  SwipeableTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SwipeableTableGenerator: BaseCellGenerator<TitleTableViewCell>, RDDMSwipeableItem {

    // MARK: - SwipeableItem

    var didSwipeEvent = BaseEvent<String>()
    var actionTypes = [String]()

}
