//
//  SwipeActionProvider.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class SwipeActionProvider: SwipeActionsProvider {

    // MARK: - Enum

    enum SwipeActionType: String {
        case edit
        case more
        case flag
    }

    // MARK: - Constants

    private enum Constants {
        static let trailingModels: [SwipeAction] = [
            .init(backgroundColor: .gray, image: #imageLiteral(resourceName: "edit"), type: SwipeActionType.edit.rawValue, style: .normal),
            .init(title: "More", backgroundColor: .blue, type: SwipeActionType.more.rawValue, style: .normal),
            .init(title: "Flag", backgroundColor: .systemRed, type: SwipeActionType.flag.rawValue, style: .normal)
        ]
        static let leadingModels: [SwipeAction] = [
            .init(title: "Delete", backgroundColor: .systemRed, type: SwipeActionType.edit.rawValue, style: .normal),
            .init(title: "Info", backgroundColor: .gray, type: SwipeActionType.more.rawValue, style: .normal),
            .init(title: "Apply", backgroundColor: .green, type: SwipeActionType.flag.rawValue, style: .normal)
        ]
    }

    // MARK: - Properties

    var isEnableSwipeActions = true

    // MARK: - TableSwipeActionsProvider

    func getLeadingSwipeActionsForGenerator(_ generator: SwipeableItem) -> SwipeActionsConfiguration? {
        guard isEnableSwipeActions else { return nil }
        return SwipeActionsConfiguration(actions: Constants.leadingModels, performsFirstActionWithFullSwipe: false)
    }

    func getTrailingSwipeActionsForGenerator(_ generator: SwipeableItem) -> SwipeActionsConfiguration? {
        guard isEnableSwipeActions else { return nil }
        return SwipeActionsConfiguration(actions: Constants.trailingModels, performsFirstActionWithFullSwipe: false)
    }

}
