//
//  TableCommonModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

class TableCommonModifier: Modifier<UITableView, UITableView.RowAnimation> {

    // MARK: - Properties

    private var animator: Animator<UITableView>?

    // MARK: - Init

    init(view: UITableView, animator: Animator<UITableView>) {
        super.init(view: view)
        self.animator = animator
    }

    // MARK: - Methods

    /// Reload all table content
    override func reload() {
        view?.reloadData()
    }

    /// Reload rows with animation
    ///
    /// - parameter indexPaths: indexes of reloaded rows
    /// - parameter updateAnimation: animation of reloaded rows
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.reloadRows(at: indexPaths, with: updateAnimation)
        }
    }

    /// Reload sections with animation
    ///
    /// - parameter indexPaths: indexes of reloaded sections
    /// - parameter updateAnimation: animation of reloaded sections
    override func reloadScetions(at indexPaths: IndexSet, with updateAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.reloadSections(indexPaths, with: updateAnimation)
        }
    }


    /// Replace row at specified indexPath
    ///
    /// - parameter indexPath: index of replaced row
    /// - parameter removeAnimation: animation of removing old row
    /// - parameter insertAnimation: animation of inserting new row
    override func replace(at indexPath: IndexPath, with removeAnimation: UITableView.RowAnimation, and insertAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.deleteRows(at: [indexPath], with: removeAnimation)
            view?.insertRows(at: [indexPath], with: insertAnimation)
        }
    }

    /// Insert sections with animation
    ///
    /// - parameter indexPaths: indexes of inserted sections
    /// - parameter insertAnimation: animation of inserted sections
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.insertSections(indexPaths, with: insertAnimation)
        }
    }

    /// Insert rows with animation
    ///
    /// - parameter indexPaths: indexes of inserted rows
    /// - parameter insertAnimation: animation of inserted rows
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.insertRows(at: indexPaths, with: insertAnimation)
        }
    }

    /// Remove rows and section with animation
    ///
    /// - parameter indexPaths: index of removed rows
    /// - parameter section: index of removed sections
    /// - parameter removeAnimation: animation of removing old row
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: UITableView.RowAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view) { [weak view] in
            view?.deleteRows(at: indexPaths, with: removeAnimation)
            if let section = section {
                view?.deleteSections(section, with: removeAnimation)
            }
        }
    }

}
