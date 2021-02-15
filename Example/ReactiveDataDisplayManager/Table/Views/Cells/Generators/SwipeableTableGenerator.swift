//
//  SwipeableTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class SwipeableTableGenerator: TitleTableGenerator, SwipeableItem {

    // MARK: - Events

    var didSwipeEvent = BaseEvent<String>()

    // MARK: - Properties

    var actionTypes = [String]()

}
