//
//  TableCommonModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

/// Helper class to modify `UITableView` cells
///
/// - Note: Based on standard `UITableView` methods wrapped in `Animator`
class TableCommonModifier: Modifier<UITableView, UITableView.RowAnimation> {

    // MARK: - Properties

    private var animator: Animator<UITableView>?

    // MARK: - Init

    /// - parameter view: parent view
    /// - parameter animator: wrapper of animated operation blocks
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
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != nil) { [weak view] in
            view?.reloadRows(at: indexPaths, with: updateAnimation ?? .none)
        }
    }

    /// Reload sections with animation
    ///
    /// - parameter indexPaths: indexes of reloaded sections
    /// - parameter updateAnimation: animation of reloaded sections
    override func reloadSections(at indexPaths: IndexSet, with updateAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != nil) { [weak view] in
            view?.reloadSections(indexPaths, with: updateAnimation ?? .none)
        }
    }

    /// Replace row at specified indexPath
    ///
    /// - parameter indexPath: index of replaced row
    /// - parameter animation: group of animations for removing of old row and insrting new
    open override func replace(at indexPath: IndexPath,
                               with animation: Modifier<UITableView, UITableView.RowAnimation>.AnimationGroup?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: animation != nil) { [weak view] in
            view?.deleteRows(at: [indexPath], with: animation?.remove ?? .none)
            view?.insertRows(at: [indexPath], with: animation?.insert ?? .none)
        }
    }

    /// Replace row at specified indexPath
    ///
    /// - parameters:
    ///     - parameter indexPaths: array with index of removed row
    ///     - parameter insertIndexPaths: array with index of inserted row
    ///     - parameter animation: group of animations for removing of old row and insrting new
    open override func replace(at indexPaths: [IndexPath],
                               on insertIndexPaths: [IndexPath],
                               with animation: Modifier<UITableView, UITableView.RowAnimation>.AnimationGroup?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: animation != nil) { [weak view] in
            view?.deleteRows(at: indexPaths, with: animation?.remove ?? .none)
            view?.insertRows(at: insertIndexPaths, with: animation?.insert ?? .none)
        }
    }

    /// Insert new sections with rows at specific position with animation
    ///
    /// - parameter indexDictionary: dictionary where **key** is new section index and value is location of subviews to insert
    /// - parameter insertAnimation: animation of insert operation
    ///  - Warning: make sure that you do not have mistake in indexes inside `indexDictionary`.
    ///  For example, if you are inserting **many sections** using this method you should notice that **index** cannot be greater than **final number of sections**.
    override func insertSectionsAndRows(at indexDictionary: [Int: [IndexPath]],
                                        with insertAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            let setOfKeys = IndexSet(indexDictionary.keys)
            let allValues = indexDictionary.values.flatMap { $0 }
            view?.insertSections(setOfKeys, with: insertAnimation ?? .none)
            view?.insertRows(at: allValues, with: insertAnimation ?? .none)
        }
    }

    /// Insert sections with animation
    ///
    /// - parameter indexPaths: indexes of inserted sections
    /// - parameter insertAnimation: animation of inserted sections
    ///  - Warning: This method will insert an **empty** section only. If you need to insert section with rows use `insertSectionsAndRows` instead.
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            view?.insertSections(indexPaths, with: insertAnimation ?? .none)
        }
    }

    /// Insert rows with animation
    ///
    /// - parameter indexPaths: indexes of inserted rows
    /// - parameter insertAnimation: animation of inserted rows
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            view?.insertRows(at: indexPaths, with: insertAnimation ?? .none)
        }
    }

    /// Remove rows and section with animation
    ///
    /// - parameter indexPaths: index of removed rows
    /// - parameter section: index of removed sections
    /// - parameter removeAnimation: animation of removing old row
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: UITableView.RowAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: removeAnimation != nil) { [weak view] in
            view?.deleteRows(at: indexPaths, with: removeAnimation ?? .none)
            if let section = section {
                view?.deleteSections(section, with: removeAnimation ?? .none)
            }
        }
    }

}
