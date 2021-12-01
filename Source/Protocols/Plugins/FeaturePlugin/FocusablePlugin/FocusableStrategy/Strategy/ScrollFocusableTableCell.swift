//
//  ScrollFocusableTableCell.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Scroll to when focusing
public final class ScrollFocusableTableCell: FocusableStrategy<UITableView> {

    // MARK: - Private Properties

    private var position: UITableView.ScrollPosition

    // MARK: - Initialization

    public init(position: FocusableAlign<UITableView>) {
        self.position = position.getPosition()
    }

    // MARK: - FocusableStrategy

    // Configure scroll
    override func didUpdateFocus(previusView: UIView?,
                                 nextView: UIView?,
                                 indexPath: IndexPath?,
                                 collection: UITableView?) {
        guard let index = indexPath else {
            return
        }
        collection?.scrollToRow(at: index, at: position, animated: true)
    }

}
