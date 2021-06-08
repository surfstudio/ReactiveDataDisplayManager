//
//  SwipeActionProvider.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class SwipeActionProvider: TableSwipeActionsProvider {

    // MARK: - Enum

    enum SwipeActionType: String {
        case edit
        case more
        case flag
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [TableSwipeAction] = [
            .init(backgroundColor: .gray, image: #imageLiteral(resourceName: "edit"), type: SwipeActionType.edit.rawValue, style: .normal),
            .init(title: "More", backgroundColor: .blue, type: SwipeActionType.more.rawValue, style: .normal),
            .init(title: "Flag", backgroundColor: .systemRed, type: SwipeActionType.flag.rawValue, style: .normal)
        ]
    }

    // MARK: - Properties

    var isEnableSwipeActions = true

    // MARK: - TableSwipeActionsProvider

    func getLeadingSwipeActionsForGenerator(_ generator: SwipeableItem) -> TableSwipeActionsConfiguration? {
        return nil
    }

    func getTrailingSwipeActionsForGenerator(_ generator: SwipeableItem) -> TableSwipeActionsConfiguration? {
        guard isEnableSwipeActions else { return nil }
        return TableSwipeActionsConfiguration(actions: Constants.models, performsFirstActionWithFullSwipe: false)
    }

}
