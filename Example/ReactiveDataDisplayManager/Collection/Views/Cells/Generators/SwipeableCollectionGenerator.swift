//
//  SwipeableCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 19.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SwipeableCollectionGenerator: BaseCollectionCellGenerator<TitleCollectionListCell>, SwipeableItem {

    // MARK: - SwipeableItem

    var didSwipeEvent = BaseEvent<String>()
    var actionTypes = [String]()

}
