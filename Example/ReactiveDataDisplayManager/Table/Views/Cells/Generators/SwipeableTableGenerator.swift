//
//  SwipeableTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SwipeableTableGenerator: BaseCellGenerator<TitleTableViewCell>, SwipeableItem {

    // MARK: - SwipeableItem

    var didSwipeEvent = Event<String>()
    var actionTypes = [String]()

}
