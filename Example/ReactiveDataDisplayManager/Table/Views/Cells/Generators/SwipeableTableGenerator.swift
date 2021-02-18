//
//  SwipeableTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SwipeableTableGenerator: BaseTitleTableGenerator, SwipeableItem {

    // MARK: - Events

    var didSwipeEvent = BaseEvent<String>()

    // MARK: - Properties

    var actionTypes = [String]()

}
